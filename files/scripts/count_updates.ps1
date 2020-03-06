$criteria = "Type='software' and IsAssigned=1 and IsHidden=0 and IsInstalled=0"

$searcher = (New-Object -COM Microsoft.Update.Session).CreateUpdateSearcher()
$updates  = $searcher.Search($criteria).Updates

if ($updates.Count -ne 0) {
  echo $updates.Count
} else {
  echo "0"
}

