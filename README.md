# glftrackeR: Automated Git LFS Tracking for Large Files

**Quick summary:**  
This R script scans a directory for files larger than **100 MB** and automatically adds them to `.gitattributes` for **Git LFS tracking**. It’s useful for keeping large datasets, media files, or other heavy resources out of your main Git history.

**How to use:**  
1. Make sure Git LFS is installed and initialized for your system and repository:
   ```bash
   git lfs install
   ```
   This sets up Git Large File Storage on your machine (you only need to do this once per system).
2. Copy `large-file-trackeR.R` into your repository.  
3. Open and run the script in your preferred IDE.  
4. After it runs, add and commit the updated `.gitattributes` file:
   ```bash
   git add .gitattributes
   git commit -m "Track large files with Git LFS"
   ```

**Important:** Always commit large files via Git LFS; trying to push them normally will fail.

For more details check out the official [Git Large File Storage Documentation](https://git-lfs.com/).
