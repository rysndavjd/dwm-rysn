#include <chrono>
#include <iostream>
#include <sys/wait.h>
#include <unistd.h>
#include <filesystem>
#include <thread>

bool commandExists(const std::string& command) {
    return std::filesystem::exists(command);
}

int main() {
if (! commandExists("/usr/bin/xsetroot")) {
    std::cerr << "xsetroot not found!!!" << std::endl;
    return 1;
}

while (true) {
    auto now = std::chrono::system_clock::now();
    auto now_c = std::chrono::system_clock::to_time_t(now);
    auto now_seconds = std::chrono::duration_cast<std::chrono::seconds>(now.time_since_epoch());
    int current_minute = now_seconds.count() % 60;
    int next_minute = 60 - current_minute;
    
    std::ostringstream oss;
    oss << std::put_time(std::localtime(&now_c), "%b %d, %a %I:%M");
    std::string formatted_time = oss.str();    

    pid_t xsetroot = fork();
    if (xsetroot == 0) {
        execl("/usr/bin/xsetroot", "xsetroot", "-name", formatted_time.c_str(), NULL);
        std::cerr << "execl failed!" << std::endl;
        return 1; 
    } else if (xsetroot > 0) {
    waitpid(xsetroot, nullptr, 0);
    } else {
        std::cerr << "fork failed!" << std::endl;
        return 1;
    }
    std::this_thread::sleep_for(std::chrono::seconds(next_minute));
}
return 0;
}