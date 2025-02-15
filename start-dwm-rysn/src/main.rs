use std::process::Command;
use signal_hook::consts::signal::*;
use signal_hook::iterator::Signals;
use std::io::Error;
use libc;

fn main() {

    let exec: Vec<&str> = vec!["ls", "-a", "\0", "ls", "-l", "\0", "sleep", "10", "\0"];
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
}

