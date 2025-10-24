# R Script to find files larger than 100 MB in a directory
# Identifies large files and automatically adds them to the .gitattributes file
# to enable Git LFS tracking.

# 1. Configuration
# ---
# Specify the directory you want to scan.
# '.' refers to the current working directory.
target_dir <- "."

# Define the size threshold (100 MB in bytes)
# 100 * 1024 * 1024 = 104857600 bytes
size_threshold_bytes <- 100 * 1024 * 1024

# Define the path for the .gitattributes file (created in the current directory)
gitattributes_path <- file.path(target_dir, ".gitattributes")
lfs_command <- " filter=lfs diff=lfs merge=lfs -text"

# 2. Get file information
# ---
# Get a list of all files (including those in subdirectories)
all_files <- list.files(
  path = target_dir,
  recursive = TRUE,
  full.names = TRUE,
  # Exclude directories themselves from the list
  include.dirs = FALSE
)

# Get detailed file information (including size)
file_info <- file.info(all_files)

# 3. Filter for large files
# ---
# Filter the information to only include files larger than the threshold
large_files_info <- file_info[
  file_info$size > size_threshold_bytes & !is.na(file_info$size),
]

# 4. Process results: Update .gitattributes
# ---
if (nrow(large_files_info) > 0) {
  # The row names of the file.info object are the file paths
  large_file_paths <- rownames(large_files_info)

  # Format the paths for .gitattributes
  lfs_entries <- paste0(large_file_paths, lfs_command)

  large_file_paths <- sub("^\\./", "", large_file_paths)

  # Write the lines to .gitattributes, appending to existing file if present.
  # Use an explicit file connection opened in 'append' mode ("a") for backward
  # compatibility with older R versions that don't support writeLines(append=TRUE).
  con <- file(gitattributes_path, open = "a")
  writeLines(lfs_entries, con = con, sep = "\n")
  close(con)

  # Print success message and the paths
  cat(paste0(
    "--- ",
    nrow(large_files_info),
    " large files ( > 100 MB) added to: ",
    gitattributes_path,
    " ---\n"
  ))
  cat("Paths added:\n")
  cat(paste(large_file_paths, collapse = "\n"), "\n")
  cat("\nAction: Run 'git add .gitattributes' and commit the changes.\n")
} else {
  cat(paste0("No files larger than 100 MB found in: ", target_dir, "\n"))
}

# End of script
