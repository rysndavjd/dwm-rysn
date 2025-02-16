use std::{error::Error, thread, process::Command, process::Stdio};
use signal_hook::consts::signal::{SIGTERM, SIGINT, SIGQUIT};
use signal_hook::iterator::Signals;
use nix::sys::signal::{kill, Signal};
use nix::unistd::Pid;

fn main() -> Result<(), Box<dyn Error>> {
    /*
    xrandr --output HDMI-0 --dpi 92 --rate 74.97 --primary --mode 1920x1080 --pos 0x0
    wmname LG3D &
    xset -dpms s off s noblank s 0 0 s noexpose &
    xsettingsd &
    xrdb -merge /home/rysndavjd/.Xresources &
    gentoo-pipewire-launcher &
    dbus-launch --sh-syntax --exit-with-session dwm
     */
    let exec: Vec<&str> = vec!["xrandr", "--output", "HDMI-0", "--dpi", "92", "--rate", "74.97", "--primary", "--mode", "1920x1080", "--pos", "0x0", "\0",
                            "wmname", "LG3D", "\0", 
                            "xset", "-dpms", "s", "off", "s", "noblank", "s", "0", "0", "s", "noexpose", "\0",
                            "xsettingsd", "\0",
                            "xrdb -merge /home/rysndavjd/.Xresources", "\0",
                            "gentoo-pipewire-launcher", "\0",
                            "dbus-launch", "--sh-syntax", "--exit-with-session", "dwm", "\0"];
    #[cfg(debug_assertions)]
    println!("{:?}", exec);

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

    let mut program: Vec<&str> = Vec::new();
    let mut pids: Vec<u32> = Vec::new();

    for item in exec {
        match item {
            "\0" => {
                let mut command = Command::new(program[0]);
                for arg in program.iter().skip(1) {
                    command.arg(arg);
                }
                if let Ok(child) = command.stdout(Stdio::piped()).stderr(Stdio::piped()).spawn() {
                    pids.push(child.id());
                } else {
                    println!("{} command didn't start", program[0]);
                }
                #[cfg(debug_assertions)]
                println!("{:?}", program);
                program.clear();
            },
            _ => {
                program.push(item);
            },
        }
        
    }
    #[cfg(debug_assertions)]
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

