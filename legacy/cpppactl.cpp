#include <iostream>
#include <unistd.h>
#include <filesystem>
#include <sys/wait.h>

const std::string vol_amount = "10"; 

int main(int argc, char* argv[]) {
    if (! std::filesystem::exists("/usr/bin/pactl")) {
        std::cerr << "pactl not found!!!" << std::endl;
        return 1;
    }

    if (argc == 1) {
        std::cerr << "Argument required (inc, dec, mute)" << std::endl;
        return 1;
    }

    if (std::string(argv[1]) == "inc") {
        std::string inc_vol = "+" + vol_amount + "%";
        execl("/usr/bin/pactl", "pactl", "set-sink-volume", "@DEFAULT_SINK@", inc_vol.c_str(), nullptr);
        return 0;
    } else if (std::string(argv[1]) == "dec") {
        std::string dec_vol = "-" + vol_amount + "%";
        execl("/usr/bin/pactl", "pactl", "set-sink-volume", "@DEFAULT_SINK@", dec_vol.c_str(), nullptr);
        return 0;
    } else if (std::string(argv[1]) == "mute") {
        execl("/usr/bin/pactl", "pactl", "set-sink-mute", "@DEFAULT_SINK@", "toggle", nullptr);
        return 0;
    }
    std::cerr << "Unknown argument: " << argv[1] << std::endl;
    return 1; 
}