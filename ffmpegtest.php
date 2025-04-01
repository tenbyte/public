<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>FFmpeg Test</title>
    <style>
        body { font-family: monospace; background: #111; color: #0f0; padding: 20px; }
        pre { background: #007AFF; padding: 10px; border: 1px solid #444; overflow-x: auto; }
    </style>
</head>
<body>
    <h1>FFmpeg Test</h1>
    <h2>ffmpeg PATH:</h2>
    <pre><?php echo shell_exec('which ffmpeg'); ?></pre>

    <h2>FFmpeg Version:</h2>
    <pre><?php echo shell_exec('ffmpeg -version 2>&1'); ?></pre>
</body>
</html>
