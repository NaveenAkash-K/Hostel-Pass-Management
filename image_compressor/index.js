const fs = require("fs");
const path = require("path");
const sharp = require("sharp");

const inputDir = "C:/Users/subas/Desktop/QR Automation/gh_block1";
const outputDir = "C:/Users/subas/Desktop/QR Automation/gh_block1/compressed";

if (!fs.existsSync(outputDir)) {
  fs.mkdirSync(outputDir, { recursive: true });
}

fs.readdir(inputDir, (err, files) => {
  if (err) {
    console.error("Error reading directory:", err);
    return;
  }

  const imageFiles = files.filter((file) =>
    /\.(jpg|jpeg|png|webp)$/i.test(file)
  );

  if (imageFiles.length === 0) {
    console.log("No image files found in the directory.");
    return;
  }

  imageFiles.forEach((file) => {
    const inputPath = path.join(inputDir, file);
    const outputPath = path.join(outputDir, file);

    sharp(inputPath)
      .resize({ width: 800 })
      .jpeg({ quality: 70 })
      .toFile(outputPath)
      .then(() => console.log(`Compressed: ${file}`))
      .catch((err) => console.error(`Error compressing ${file}:`, err));
  });
});
