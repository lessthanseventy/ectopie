#![cfg_attr(
    all(not(debug_assertions), target_os = "windows"),
    windows_subsystem = "windows"
)]

use std::process::Stdio;
use tauri::api::process::Command;
use tauri::Manager;
use tauri::Wry;
use tokio::sync::mpsc;
use tokio::sync::Mutex;
use tracing::info;

use std::env;
use std::ffi::OsString;
use std::path::Path;

struct AsyncProcInputTx {
    inner: Mutex<mpsc::Sender<String>>,
}

fn main() {
    tracing_subscriber::fmt::init();

    let (async_proc_input_tx, async_proc_input_rx) = mpsc::channel(1);
    let (async_proc_output_tx, mut async_proc_output_rx) = mpsc::channel(1);

    tauri::Builder::default()
        .manage(AsyncProcInputTx {
            inner: Mutex::new(async_proc_input_tx),
        })
        .invoke_handler(tauri::generate_handler![js2rs])
        .setup(|app| {
            tauri::async_runtime::spawn(async move {
                async_process_model(async_proc_input_rx, async_proc_output_tx).await
            });

            let app_handle = app.handle();
            tauri::async_runtime::spawn(async move {
                loop {
                    if let Some(output) = async_proc_output_rx.recv().await {
                        rs2js(output, &app_handle);
                    }
                }
            });

            Ok(())
        })
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}

fn rs2js<R: tauri::Runtime>(message: String, manager: &impl Manager<R>) {
    info!(?message, "rs2js");
    manager
        .emit_all("rs2js", format!("rs: {}", message))
        .unwrap();
}

#[tauri::command]
async fn js2rs(message: String, state: tauri::State<'_, AsyncProcInputTx>) -> Result<(), String> {
    info!(?message, "js2rs");
    let async_proc_input_tx = state.inner.lock().await;
    async_proc_input_tx
        .send(message)
        .await
        .map_err(|e| e.to_string())
}

async fn async_process_model(
    mut input_rx: mpsc::Receiver<String>,
    output_tx: mpsc::Sender<String>,
) -> Result<(), Box<dyn std::error::Error + Send + Sync>> {
    while let Some(input) = input_rx.recv().await {
        let output = input;
        output_tx.send(output).await?;
    }

    Ok(())
}

// Takes the name of the binary and returns the full path to its location
fn get_bin_command(name: &str) -> Result<(OsString), env::JoinPathsError> {
    let paths = [tauri::api::command::binary_command(name.to_string()).unwrap()];
    let path_string = env::join_paths(paths.iter())?;
    Ok(path_string)
}

// Spawns ectoprint server and loads url in webview
fn spawn_ectoprint_server(handle: &mut tauri::Builder<Wry>) {
    println!("running");
    // Get paths to orchestrator and main binary
    let ectoprint_binary = get_bin_command("ectoprint");
    let orchestrator_binary = get_bin_command("ectoprint-orchestrator");

    // Get stdout from binary
    println!("orchestator binary: {}", orchestrator_binary);
    let stdout = Command::new(orchestrator_binary)
        .args(vec!["run", ectoprint_binary])
        .stdout(Stdio::piped())
        .spawn()
        .expect("Failed to start ectoprint server")
        .stdout
        .expect("Failed to get ectoprint server stdout");

    // Read stdout
    let reader = BufReader::new(stdout);
    let mut webview_started = false;
    reader
        .lines()
        .filter_map(|line| line.ok())
        // Check if binary has printed the url to the console
        .for_each(|line| {
            if line.starts_with("root INFO ectoprint app listening on ") {
                // Extract url from stdout line
                let url = line
                    .replace("root INFO ectoprint app listening on ", "")
                    .replace(".", "");
                // If the webview hasn't started yet, load the url of the server
                println!("Loading, started: {}", webview_started);
                if !webview_started {
                    webview_started = true;
                    handle
                        .dispatch(move |webview| {
                            webview.eval(&format!("window.location.replace('{}')", url))
                        })
                        .expect("failed to initialize app");
                }
            }
        });
}
