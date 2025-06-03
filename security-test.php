<?php
// Simple test to verify security features
echo "<h1>Security Test</h1>";

// Test 1: Check if dangerous functions are disabled
echo "<h2>1. Dangerous Functions Test</h2>";
$disabled_functions = explode(',', ini_get('disable_functions'));
$test_functions = ['exec', 'system', 'shell_exec', 'passthru'];
foreach ($test_functions as $func) {
    if (in_array($func, $disabled_functions)) {
        echo "✓ $func is disabled<br>";
    } else {
        echo "✗ $func is NOT disabled<br>";
    }
}

// Test 2: Check open_basedir
echo "<h2>2. Open Basedir Test</h2>";
$open_basedir = ini_get('open_basedir');
if ($open_basedir) {
    echo "✓ open_basedir is set to: $open_basedir<br>";
} else {
    echo "✗ open_basedir is not set<br>";
}

// Test 3: Check upload limits
echo "<h2>3. Upload Limits Test</h2>";
$upload_max = ini_get('upload_max_filesize');
$post_max = ini_get('post_max_size');
echo "✓ upload_max_filesize: $upload_max<br>";
echo "✓ post_max_size: $post_max<br>";

echo "<h2>4. Security Headers Test</h2>";
echo "Check browser developer tools to verify security headers are present.<br>";
?>