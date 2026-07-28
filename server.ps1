$root = "C:\Users\rapae\Downloads\michellegore-copy"
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:3000/")
$listener.Start()
Write-Host "Running at http://localhost:3000"
$mime = @{'.html'='text/html;charset=utf-8';'.css'='text/css;charset=utf-8';'.js'='application/javascript;charset=utf-8';'.mp4'='video/mp4';'.mov'='video/quicktime';'.svg'='image/svg+xml';'.png'='image/png';'.jpg'='image/jpeg';'.gif'='image/gif';'.woff'='font/woff';'.woff2'='font/woff2'}
while ($listener.IsListening) {
  $ctx = $listener.GetContext()
  $p = $ctx.Request.Url.LocalPath; if ($p -eq '/') { $p = '/index.html' }
  $f = Join-Path $root ($p.TrimStart('/').Replace('/','\'))
  $r = $ctx.Response; $r.Headers.Add('Access-Control-Allow-Origin','*')
  if (Test-Path $f -PathType Leaf) {
    $ext = [IO.Path]::GetExtension($f).ToLower()
    $b = [IO.File]::ReadAllBytes($f)
    $r.StatusCode=200; $r.ContentType=if($mime[$ext]){$mime[$ext]}else{'application/octet-stream'}
    $r.ContentLength64=$b.Length; $r.OutputStream.Write($b,0,$b.Length)
  } else { $r.StatusCode=404 }
  $r.OutputStream.Close()
}