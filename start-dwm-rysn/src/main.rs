use std::{error::Error, thread, process::Command};
use signal_hook::consts::signal::{SIGTERM, SIGINT, SIGQUIT};
use signal_hook::iterator::Signals;
use nix::sys::signal::{kill, Signal};
use nix::unistd::Pid;

fn main() -> Result<(), Box<dyn Error>> {
    let mut signals = Signals::new(&[
        SIGTERM,
        SIGINT,
        SIGQUIT,
    ])?;

    let signal_thread = thread::spawn(move || {
        for sig in signals.forever() {
            println!("Received signal {:?}", sig);
            break;
        }
    });

    let exec: Vec<&str> = vec!["sleep", "30", "\0", "sleep", "30", "\0", "sleep", "30", "\0"];
    let mut program: Vec<&str> = Vec::new();
    let mut pids: Vec<u32> = Vec::new();

    for item in exec {
        match item {
            "\0" => {
                let mut command = Command::new(program[0]);
                for arg in program.iter().skip(1) {
                    command.arg(arg);
                }
                if let Ok(child) = command.spawn() {
                    pids.push(child.id());
                } else {
                    println!("{} command didn't start", program[0]);
                }
                println!("{:?}", program);
                program.clear();
            },
            _ => {
                program.push(item);
            },
        }
        
    }
    println!("{:?}", pids);
    signal_thread.join().expect("Failed to join signal_thread.");

    for pidu32 in pids {
        let pid = Pid::from_raw(pidu32 as i32);
        match kill(pid, Signal::SIGTERM) {
            Ok(_) => (),
            Err(e) => eprintln!("Failed sending signal {}", e)
        }
    }
    Ok(())
}

