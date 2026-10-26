/*
 * pokecycle.c - Ultra-lightweight in-memory frame cycler for PokeBar
 * Author: Aditya Malkar (https://github.com/adimalkar)
 * License: MIT
 *
 * Runs in ~0.2ms with zero disk I/O using /dev/shm.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/stat.h>

#define DEFAULT_SHM "/dev/shm/pokebar_idx"
#define FALLBACK_TMP "/tmp/pokebar_idx"

int main(int argc, char *argv[]) {
    const char *home = getenv("HOME");
    if (!home) home = "/tmp";

    // Allow override via environment or config
    const char *custom_dir = getenv("POKEBAR_CURRENT_DIR");
    char current_dir[512];
    if (custom_dir && custom_dir[0]) {
        snprintf(current_dir, sizeof(current_dir), "%s", custom_dir);
    } else {
        snprintf(current_dir, sizeof(current_dir), "%s/.config/pokebar/current", home);
    }

    // Determine state file location (/dev/shm preferred for zero disk writes)
    const char *state_file = DEFAULT_SHM;
    struct stat st;
    if (stat("/dev/shm", &st) != 0 || !S_ISDIR(st.st_mode)) {
        state_file = FALLBACK_TMP;
    }

    // Read frame count from meta.txt or count frames
    int total_frames = 4;
    char meta_path[512];
    snprintf(meta_path, sizeof(meta_path), "%s/meta.txt", current_dir);
    FILE *mf = fopen(meta_path, "r");
    if (mf) {
        if (fscanf(mf, "%d", &total_frames) != 1 || total_frames <= 0) {
            total_frames = 4;
        }
        fclose(mf);
    }

    // Read and increment frame index
    int idx = 0;
    FILE *sf = fopen(state_file, "r+");
    if (!sf) {
        sf = fopen(state_file, "w+");
    }
    if (sf) {
        if (fscanf(sf, "%d", &idx) != 1 || idx < 0) {
            idx = 0;
        }
        idx = (idx + 1) % total_frames;
        rewind(sf);
        fprintf(sf, "%d\n", idx);
        fclose(sf);
    }

    // Output path to stdout for status bar consumption
    printf("%s/frame_%d.png\n", current_dir, idx);
    return 0;
}
