<?php
/**
 * ==========================================================
 *  MTN GHANA – REST Web Service Client
 *  File : rest_client.php
 *  Path : C:\xampp\htdocs\REST_Web_Service\rest_client.php
 *  URL  : http://localhost/REST_Web_Service/rest_client.php
 * ==========================================================
 *  Sends HTTP requests via PHP cURL to rest_api.php.
 *  Parses XML responses with PHP SimpleXML.
 *  Uses ?r= routing — reliable on all XAMPP setups.
 *
 *  GET    ?r=employees
 *  GET    ?r=employees&id=MTN-GH-0001
 *  GET    ?r=employees&dept=Technology
 *  POST   ?r=employees              (JSON body)
 *  PUT    ?r=employees&id=MTN-GH-0001
 *  DELETE ?r=employees&id=MTN-GH-0001
 *
 *  GET    ?r=products
 *  GET    ?r=products&id=MTN-DATA-01
 *  GET    ?r=products&category=data
 *  POST   ?r=products
 *  PUT    ?r=products&id=MTN-DATA-01
 *  DELETE ?r=products&id=MTN-DATA-01
 *
 *  GET    ?r=subscribers
 *  GET    ?r=subscribers&id=0244100001
 *  GET    ?r=subscribers&region=Ashanti
 *  POST   ?r=subscribers
 *  PUT    ?r=subscribers&id=0244100001
 *  DELETE ?r=subscribers&id=0244100001
 *
 *  GET    ?r=company
 * ==========================================================
 */

declare(strict_types=1);

$baseUrl   = 'http://localhost/REST_Web_Service/rest_api.php';
$result    = null;
$error     = null;
$timeTaken = 0;
$httpCode  = 0;
$rawReq    = '';
$rawRes    = '';

// ── Operations ─────────────────────────────────────────────
// endpoint = ?r=... base
// paramkey = query key to append (&id=, &dept=, etc.)
// ph       = placeholder value shown in input
// body     = false | 'json'
$operations = [
    // ── Employees ──────────────────────────────────────────
    'getAllEmployees' => [
        'label'    => 'Get All Employees',
        'tag'      => 'GET · no params',
        'method'   => 'GET',
        'endpoint' => '?r=employees',
        'paramkey' => '',
        'ph'       => '',
        'body'     => false,
        'body_ph'  => '',
        'group'    => 'Employees',
    ],
    'getEmployee' => [
        'label'    => 'Get Employee by ID',
        'tag'      => 'GET · staff_id',
        'method'   => 'GET',
        'endpoint' => '?r=employees',
        'paramkey' => 'id',
        'ph'       => 'MTN-GH-0001',
        'body'     => false,
        'body_ph'  => '',
        'group'    => 'Employees',
    ],
    'getEmployeesByDept' => [
        'label'    => 'Get Employees by Dept',
        'tag'      => 'GET · department',
        'method'   => 'GET',
        'endpoint' => '?r=employees',
        'paramkey' => 'dept',
        'ph'       => 'Technology',
        'body'     => false,
        'body_ph'  => '',
        'group'    => 'Employees',
    ],
    'createEmployee' => [
        'label'    => 'Create Employee',
        'tag'      => 'POST · JSON body',
        'method'   => 'POST',
        'endpoint' => '?r=employees',
        'paramkey' => '',
        'ph'       => '',
        'body'     => 'json',
        'body_ph'  => "{\n  \"staff_id\": \"MTN-GH-0010\",\n  \"full_name\": \"Akua Mensah\",\n  \"department\": \"Technology\",\n  \"job_title\": \"Systems Analyst\",\n  \"email\": \"akua.mensah@mtn.com.gh\",\n  \"phone\": \"0244001010\",\n  \"salary_ghs\": 7000,\n  \"hire_date\": \"2025-06-01\"\n}",
        'group'    => 'Employees',
    ],
    'updateEmployee' => [
        'label'    => 'Update Employee',
        'tag'      => 'PUT · id + body',
        'method'   => 'PUT',
        'endpoint' => '?r=employees',
        'paramkey' => 'id',
        'ph'       => 'MTN-GH-0001',
        'body'     => 'json',
        'body_ph'  => "{\n  \"salary_ghs\": 9500,\n  \"status\": \"active\"\n}",
        'group'    => 'Employees',
    ],
    'deleteEmployee' => [
        'label'    => 'Delete Employee',
        'tag'      => 'DELETE · id',
        'method'   => 'DELETE',
        'endpoint' => '?r=employees',
        'paramkey' => 'id',
        'ph'       => 'MTN-GH-0010',
        'body'     => false,
        'body_ph'  => '',
        'group'    => 'Employees',
    ],
    // ── Products ───────────────────────────────────────────
    'getAllProducts' => [
        'label'    => 'Get All Products',
        'tag'      => 'GET · no params',
        'method'   => 'GET',
        'endpoint' => '?r=products',
        'paramkey' => '',
        'ph'       => '',
        'body'     => false,
        'body_ph'  => '',
        'group'    => 'Products',
    ],
    'getProduct' => [
        'label'    => 'Get Product by Code',
        'tag'      => 'GET · product_code',
        'method'   => 'GET',
        'endpoint' => '?r=products',
        'paramkey' => 'id',
        'ph'       => 'MTN-DATA-01',
        'body'     => false,
        'body_ph'  => '',
        'group'    => 'Products',
    ],
    'getProductsByCategory' => [
        'label'    => 'Get Products by Category',
        'tag'      => 'GET · category',
        'method'   => 'GET',
        'endpoint' => '?r=products',
        'paramkey' => 'category',
        'ph'       => 'data',
        'body'     => false,
        'body_ph'  => '',
        'group'    => 'Products',
    ],
    'createProduct' => [
        'label'    => 'Create Product',
        'tag'      => 'POST · JSON body',
        'method'   => 'POST',
        'endpoint' => '?r=products',
        'paramkey' => '',
        'ph'       => '',
        'body'     => 'json',
        'body_ph'  => "{\n  \"product_code\": \"MTN-DATA-04\",\n  \"product_name\": \"MTN Yearly 100GB\",\n  \"category\": \"data\",\n  \"price_ghs\": 400,\n  \"description\": \"100 GB valid 365 days\"\n}",
        'group'    => 'Products',
    ],
    'updateProduct' => [
        'label'    => 'Update Product',
        'tag'      => 'PUT · id + body',
        'method'   => 'PUT',
        'endpoint' => '?r=products',
        'paramkey' => 'id',
        'ph'       => 'MTN-DATA-02',
        'body'     => 'json',
        'body_ph'  => "{\n  \"price_ghs\": 25,\n  \"description\": \"5 GB - 7 days (updated)\"\n}",
        'group'    => 'Products',
    ],
    'deleteProduct' => [
        'label'    => 'Delete Product',
        'tag'      => 'DELETE · id',
        'method'   => 'DELETE',
        'endpoint' => '?r=products',
        'paramkey' => 'id',
        'ph'       => 'MTN-DATA-04',
        'body'     => false,
        'body_ph'  => '',
        'group'    => 'Products',
    ],
    // ── Subscribers ────────────────────────────────────────
    'getAllSubscribers' => [
        'label'    => 'Get All Subscribers',
        'tag'      => 'GET · no params',
        'method'   => 'GET',
        'endpoint' => '?r=subscribers',
        'paramkey' => '',
        'ph'       => '',
        'body'     => false,
        'body_ph'  => '',
        'group'    => 'Subscribers',
    ],
    'getSubscriber' => [
        'label'    => 'Get Subscriber',
        'tag'      => 'GET · msisdn',
        'method'   => 'GET',
        'endpoint' => '?r=subscribers',
        'paramkey' => 'id',
        'ph'       => '0244100001',
        'body'     => false,
        'body_ph'  => '',
        'group'    => 'Subscribers',
    ],
    'getSubscribersByRegion' => [
        'label'    => 'Get Subscribers by Region',
        'tag'      => 'GET · region',
        'method'   => 'GET',
        'endpoint' => '?r=subscribers',
        'paramkey' => 'region',
        'ph'       => 'Ashanti',
        'body'     => false,
        'body_ph'  => '',
        'group'    => 'Subscribers',
    ],
    'createSubscriber' => [
        'label'    => 'Create Subscriber',
        'tag'      => 'POST · JSON body',
        'method'   => 'POST',
        'endpoint' => '?r=subscribers',
        'paramkey' => '',
        'ph'       => '',
        'body'     => 'json',
        'body_ph'  => "{\n  \"msisdn\": \"0244700007\",\n  \"full_name\": \"Yaa Bonsu\",\n  \"region\": \"Bono\",\n  \"id_type\": \"Ghana Card\"\n}",
        'group'    => 'Subscribers',
    ],
    'updateSubscriber' => [
        'label'    => 'Update Subscriber',
        'tag'      => 'PUT · id + body',
        'method'   => 'PUT',
        'endpoint' => '?r=subscribers',
        'paramkey' => 'id',
        'ph'       => '0244100001',
        'body'     => 'json',
        'body_ph'  => "{\n  \"status\": \"suspended\"\n}",
        'group'    => 'Subscribers',
    ],
    'deleteSubscriber' => [
        'label'    => 'Delete Subscriber',
        'tag'      => 'DELETE · id',
        'method'   => 'DELETE',
        'endpoint' => '?r=subscribers',
        'paramkey' => 'id',
        'ph'       => '0244700007',
        'body'     => false,
        'body_ph'  => '',
        'group'    => 'Subscribers',
    ],
    // ── Company ────────────────────────────────────────────
    'getCompanyInfo' => [
        'label'    => 'Get Company Info',
        'tag'      => 'GET · no params',
        'method'   => 'GET',
        'endpoint' => '?r=company',
        'paramkey' => '',
        'ph'       => '',
        'body'     => false,
        'body_ph'  => '',
        'group'    => 'Company',
    ],
];

$methodColor = ['GET'=>'#00a651','POST'=>'#0066cc','PUT'=>'#e67e00','DELETE'=>'#e74c3c'];

// ── Execute REST call via cURL ─────────────────────────────
$operation = $_POST['operation'] ?? '';

if ($_SERVER['REQUEST_METHOD'] === 'POST' && $operation && isset($operations[$operation])) {
    $op       = $operations[$operation];
    $param    = trim($_POST['param1']    ?? '');
    $bodyRaw  = trim($_POST['body_json'] ?? '');

    // Build URL: base endpoint + optional paramkey=value
    $url = $baseUrl . $op['endpoint'];
    if ($op['paramkey'] !== '' && $param !== '') {
        $url .= '&' . $op['paramkey'] . '=' . urlencode($param);
    }

    $rawReq = $bodyRaw;

    $start = microtime(true);
    try {
        if (!function_exists('curl_init'))
            throw new RuntimeException('cURL not enabled. Open php.ini, uncomment extension=curl, restart Apache.');

        $ch = curl_init($url);
        $headers = ['Accept: application/xml'];

        if (in_array($op['method'], ['POST','PUT'], true) && $bodyRaw !== '') {
            if (json_decode($bodyRaw) === null)
                throw new InvalidArgumentException('Request body is not valid JSON.');
            $headers = ['Content-Type: application/json', 'Accept: application/xml'];
            curl_setopt($ch, CURLOPT_POSTFIELDS, $bodyRaw);
        }

        curl_setopt_array($ch, [
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_CUSTOMREQUEST  => $op['method'],
            CURLOPT_TIMEOUT        => 10,
            CURLOPT_FOLLOWLOCATION => false,
            CURLOPT_HTTPHEADER     => $headers,
        ]);

        $rawRes   = (string)curl_exec($ch);
        $httpCode = (int)curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $curlErr  = curl_error($ch);
        curl_close($ch);

        if ($curlErr) throw new RuntimeException('cURL error: ' . $curlErr);
        if ($rawRes === '') throw new RuntimeException('Empty response — is Apache running?');

        // ── Parse XML with SimpleXML ──────────────────────
        libxml_use_internal_errors(true);
        $xml = simplexml_load_string($rawRes);
        if ($xml === false) {
            $errs = libxml_get_errors(); libxml_clear_errors();
            throw new RuntimeException('SimpleXML parse error: ' . ($errs[0]->message ?? 'unknown') . ' | Raw: ' . substr($rawRes, 0, 300));
        }

        if ((string)($xml->status ?? '') === 'error') {
            $error = (string)($xml->error->message ?? 'Unknown API error');
        } else {
            $result = $xml;
        }

    } catch (Throwable $e) {
        $error = $e->getMessage();
    }
    $timeTaken = round((microtime(true) - $start) * 1000, 2);
}

// ── Render Helpers ─────────────────────────────────────────
function renderXML(SimpleXMLElement $node): string {
    $children = $node->children();
    $count    = count($children);
    if ($count === 0)
        return '<span class="v-str">' . htmlspecialchars((string)$node ?: '(empty)') . '</span>';

    // Homogeneous list → table
    $tags = [];
    foreach ($children as $c) $tags[] = $c->getName();
    if (count(array_unique($tags)) === 1 && $count > 1) {
        $cols = [];
        foreach ($children[0]->children() as $c) $cols[] = $c->getName();
        if (!empty($cols)) {
            $h = '<div class="tbl-wrap"><table class="dump-table"><thead><tr>';
            foreach ($cols as $c) $h .= '<th>' . htmlspecialchars(str_replace('_',' ',$c)) . '</th>';
            $h .= '</tr></thead><tbody>';
            foreach ($children as $row) {
                $h .= '<tr>';
                foreach ($cols as $c) $h .= '<td>' . htmlspecialchars((string)$row->$c) . '</td>';
                $h .= '</tr>';
            }
            return $h . '</tbody></table></div>';
        }
    }
    // Key-value table
    $h = '<table class="dump-table">';
    foreach ($children as $child) {
        $key = $child->getName();
        $h .= '<tr><td class="dk">' . htmlspecialchars(str_replace('_',' ',$key)) . '</td>'
            . '<td class="dv">' . (count($child->children()) > 0 ? renderXML($child)
                : '<span class="v-str">' . htmlspecialchars((string)$child) . '</span>') . '</td></tr>';
    }
    return $h . '</table>';
}

function prettyXML(string $xml): string {
    if (trim($xml) === '') return '(empty)';
    $doc = new DOMDocument('1.0');
    $doc->preserveWhiteSpace = false;
    $doc->formatOutput = true;
    libxml_use_internal_errors(true);
    return $doc->loadXML($xml) ? htmlspecialchars($doc->saveXML()) : htmlspecialchars($xml);
}

function methodBadge(string $m): string {
    $c = ['GET'=>'#00a651','POST'=>'#0066cc','PUT'=>'#e67e00','DELETE'=>'#e74c3c'][$m] ?? '#666';
    return "<span class=\"mbadge\" style=\"background:$c\">$m</span>";
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>MTN Ghana REST Client</title>
<style>
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
:root{
  --y:#FFCC00;--dark:#1a1a2e;--green:#00c851;--red:#e74c3c;
  --lt:#e8e8f0;--muted:#8888a0;--border:rgba(255,204,0,.18);
  --card:rgba(255,255,255,.04);--r:10px;
}
body{font-family:'Segoe UI',system-ui,sans-serif;background:var(--dark);color:var(--lt);min-height:100vh}
.hdr{background:linear-gradient(135deg,var(--y),#ff9900);box-shadow:0 4px 24px rgba(255,204,0,.25)}
.hdr-in{max-width:1260px;margin:0 auto;padding:16px 28px;display:flex;align-items:center;gap:16px}
.logo{width:54px;height:54px;background:var(--dark);border-radius:50%;display:flex;align-items:center;
  justify-content:center;font-weight:900;font-size:13px;color:var(--y);letter-spacing:1px;flex-shrink:0}
.hdr-text h1{color:var(--dark);font-size:1.5rem;font-weight:800}
.hdr-text p{color:rgba(26,26,46,.7);font-size:.8rem;margin-top:2px}
.sbar{background:rgba(0,0,0,.4);border-bottom:1px solid var(--border);
  padding:7px 28px;display:flex;gap:20px;font-size:.75rem;color:var(--muted);overflow-x:auto}
.sbar span{display:flex;align-items:center;gap:6px;white-space:nowrap}
.dot{width:7px;height:7px;border-radius:50%;display:inline-block}
.dot.g{background:var(--green);box-shadow:0 0 6px var(--green)}.dot.y{background:var(--y)}.dot.r{background:var(--red)}
.wrap{max-width:1260px;margin:0 auto;padding:24px 28px}
.grid{display:grid;grid-template-columns:320px 1fr;gap:22px;align-items:start}
.card{background:var(--card);border:1px solid var(--border);border-radius:var(--r);padding:22px}
.ct{font-size:.68rem;font-weight:700;letter-spacing:1.5px;text-transform:uppercase;
  color:var(--y);margin-bottom:16px;padding-bottom:10px;border-bottom:1px solid var(--border)}
.grp{font-size:.6rem;font-weight:700;letter-spacing:2px;text-transform:uppercase;
  color:var(--muted);padding:10px 2px 4px}
.op{width:100%;text-align:left;padding:10px 12px;background:transparent;
  border:1px solid transparent;border-radius:7px;color:var(--lt);
  cursor:pointer;font-size:.82rem;display:flex;align-items:center;
  gap:8px;transition:all .18s;margin-bottom:3px;text-decoration:none}
.op:hover{background:rgba(255,204,0,.07);border-color:var(--border)}
.op.active{background:rgba(255,204,0,.14);border-color:var(--y);color:var(--y)}
.op-tag{font-size:.59rem;background:rgba(255,204,0,.18);color:var(--y);
  padding:2px 7px;border-radius:20px;margin-left:auto;white-space:nowrap}
.op-tag-xml{font-size:.59rem;background:rgba(121,212,253,.15);color:#79d4fd;
  padding:2px 7px;border-radius:20px;margin-left:auto;white-space:nowrap}
.mbadge{font-size:.58rem;font-weight:800;letter-spacing:.5px;padding:2px 7px;
  border-radius:4px;color:#fff;flex-shrink:0}
.xml-icon{font-size:.68rem;font-weight:800;padding:2px 6px;border-radius:4px;
  background:rgba(121,212,253,.2);color:#79d4fd;flex-shrink:0}
.psec{margin-top:14px}
.psec label{font-size:.78rem;color:var(--muted);display:block;margin-bottom:5px}
.psec input,.psec textarea{width:100%;padding:9px 13px;background:rgba(255,255,255,.06);
  border:1px solid var(--border);border-radius:7px;color:var(--lt);
  font-size:.84rem;outline:none;transition:border-color .18s;font-family:inherit}
.psec input:focus,.psec textarea:focus{border-color:var(--y)}
.psec textarea{font-family:'Courier New',monospace;font-size:.72rem;resize:vertical;min-height:115px;line-height:1.55}
.sbtn{width:100%;margin-top:16px;padding:12px;
  background:linear-gradient(135deg,var(--y),#ff9900);
  color:var(--dark);font-weight:700;font-size:.9rem;
  border:none;border-radius:7px;cursor:pointer;transition:transform .15s,box-shadow .15s}
.sbtn:hover{transform:translateY(-1px);box-shadow:0 6px 18px rgba(255,204,0,.28)}
.sbtn:disabled{opacity:.4;cursor:not-allowed;transform:none}
.rpanel{display:flex;flex-direction:column;gap:18px}
.tabs{display:flex;gap:4px;margin-bottom:14px}
.tab{padding:7px 16px;font-size:.77rem;border-radius:6px;background:transparent;
  border:1px solid var(--border);color:var(--muted);cursor:pointer;transition:all .18s}
.tab.active{background:rgba(255,204,0,.14);color:var(--y);border-color:var(--y)}
.tbl-wrap{overflow-x:auto}
.dump-table{width:100%;border-collapse:collapse;font-size:.81rem;min-width:400px}
.dump-table thead th{padding:8px 12px;background:rgba(255,204,0,.1);color:var(--y);
  font-weight:700;text-align:left;border-bottom:2px solid rgba(255,204,0,.25);
  text-transform:uppercase;font-size:.66rem;letter-spacing:.7px;white-space:nowrap}
.dump-table .dk{padding:8px 12px;background:rgba(255,204,0,.06);color:var(--y);
  font-weight:600;border-bottom:1px solid rgba(255,255,255,.05);white-space:nowrap;vertical-align:top;width:28%}
.dump-table .dv{padding:8px 12px;border-bottom:1px solid rgba(255,255,255,.05);vertical-align:top;word-break:break-word}
.dump-table tbody td{padding:8px 12px;border-bottom:1px solid rgba(255,255,255,.05);vertical-align:top}
.dump-table tbody tr:hover td{background:rgba(255,255,255,.03)}
.v-str{color:#7ee8a2}
.xmlbox{background:rgba(0,0,0,.35);border:1px solid var(--border);border-radius:8px;
  padding:14px;overflow:auto;max-height:360px;
  font-family:'Courier New',monospace;font-size:.72rem;line-height:1.6;
  color:#c5cde8;white-space:pre-wrap;word-break:break-all}
.errbox{background:rgba(231,76,60,.1);border:1px solid rgba(231,76,60,.3);
  border-radius:8px;padding:14px;color:var(--red);font-size:.84rem}
.empty{text-align:center;padding:48px;color:var(--muted)}
.empty .ico{font-size:2.6rem;margin-bottom:10px}
.empty p{font-size:.85rem;line-height:1.7}
.meta{display:flex;gap:14px;font-size:.74rem;color:var(--muted);
  padding:10px 14px;background:rgba(0,0,0,.2);border-radius:7px;flex-wrap:wrap}
.meta strong{color:var(--y)}
.step-list{list-style:none}
.step-list li{display:flex;gap:12px;margin-bottom:14px;align-items:flex-start}
.snum{width:28px;height:28px;border-radius:50%;background:var(--y);color:var(--dark);
  display:flex;align-items:center;justify-content:center;font-weight:800;font-size:.8rem;flex-shrink:0;margin-top:1px}
.sbody h4{font-size:.83rem;margin-bottom:3px}
.sbody p{font-size:.75rem;color:var(--muted);line-height:1.55}
.sbody code{font-size:.71rem;background:rgba(255,255,255,.09);padding:1px 6px;border-radius:4px;color:var(--y);font-family:'Courier New',monospace}
.diag{background:rgba(0,0,0,.3);border:1px solid var(--border);border-radius:8px;
  padding:18px;font-family:'Courier New',monospace;font-size:.73rem;line-height:2;color:var(--muted);overflow-x:auto}
.diag .y{color:var(--y);font-weight:700}.diag .g{color:var(--green)}.diag .b{color:#79d4fd}.diag .r{color:var(--red)}
@media(max-width:860px){.grid{grid-template-columns:1fr}}
</style>
</head>
<body>

<div class="hdr">
  <div class="hdr-in">
    <div class="logo">MTN</div>
    <div class="hdr-text">
      <h1>MTN Ghana – REST Web Service Console</h1>
      <p>REST API · PHP cURL · SimpleXML · MySQL · XML Responses</p>
    </div>
  </div>
</div>

<div class="sbar">
  <span><span class="dot <?= function_exists('curl_init') ? 'g' : 'r' ?>"></span>
    cURL: <?= function_exists('curl_init') ? 'Enabled' : 'DISABLED' ?></span>
  <span><span class="dot <?= function_exists('simplexml_load_string') ? 'g' : 'r' ?>"></span>
    SimpleXML: <?= function_exists('simplexml_load_string') ? 'Enabled' : 'DISABLED' ?></span>
  <span><span class="dot g"></span> Apache: Running</span>
  <span><span class="dot y"></span> Base URL: <?= htmlspecialchars($baseUrl) ?></span>
  <span><span class="dot y"></span> PHP <?= PHP_VERSION ?></span>
  <span><span class="dot y"></span> <?= date('d M Y, H:i:s') ?></span>
</div>

<div class="wrap">
<div class="grid">

<!-- LEFT PANEL -->
<div style="display:flex;flex-direction:column;gap:18px">
  <div class="card">
    <div class="ct">⚡ REST Operations</div>
    <form method="POST" id="sf">
      <input type="hidden" name="operation" id="opInput" value="<?= htmlspecialchars($operation) ?>">

      <?php
      $lastGroup = '';
      foreach ($operations as $opKey => $opDef):
          if ($opDef['group'] !== $lastGroup) {
              $lastGroup = $opDef['group'];
              echo "<div class=\"grp\">{$lastGroup}</div>";
          }
      ?>
      <button type="button"
        class="op <?= $operation === $opKey ? 'active' : '' ?>"
        data-op="<?= $opKey ?>"
        data-hasparam="<?= $opDef['paramkey'] !== '' ? '1' : '0' ?>"
        data-paramname="<?= htmlspecialchars($opDef['paramkey']) ?>"
        data-paramph="<?= htmlspecialchars($opDef['ph']) ?>"
        data-hasbody="<?= $opDef['body'] ? '1' : '0' ?>"
        data-bodyph="<?= htmlspecialchars($opDef['body_ph']) ?>"
        onclick="selectOp(this)">
        <?= methodBadge($opDef['method']) ?>
        <?= htmlspecialchars($opDef['label']) ?>
        <span class="op-tag"><?= htmlspecialchars($opDef['tag']) ?></span>
      </button>
      <?php endforeach; ?>

      <!-- Parameter input -->
      <div class="psec" id="paramBox"
           style="<?= ($operation && ($operations[$operation]['paramkey'] ?? '') !== '') ? '' : 'display:none' ?>">
        <label id="paramLabel">Parameter</label>
        <input type="text" name="param1" id="paramInput"
          value="<?= htmlspecialchars($_POST['param1'] ?? '') ?>"
          placeholder="Enter value…">
      </div>

      <!-- JSON body -->
      <div class="psec" id="bodyBox"
           style="<?= ($operation && ($operations[$operation]['body'] ?? false)) ? '' : 'display:none' ?>">
        <label>Request Body <span style="color:var(--y)">(JSON)</span></label>
        <textarea name="body_json" id="bodyInput"
          placeholder='{"key": "value"}'><?= htmlspecialchars($_POST['body_json'] ?? '') ?></textarea>
      </div>

      <button type="submit" class="sbtn" id="runBtn" <?= $operation ? '' : 'disabled' ?>>
        ▶ Send REST Request
      </button>
    </form>
  </div>

  <!-- XML / XSL Views -->
  <div class="card">
    <div class="ct">📂 XML / XSL Data Views</div>
    <a class="op" href="employees.xml" target="_blank">
      <span class="xml-icon">XML</span>employees.xml<span class="op-tag-xml">employees.xsl</span></a>
    <a class="op" href="products.xml" target="_blank">
      <span class="xml-icon">XML</span>products.xml<span class="op-tag-xml">products.xsl</span></a>
    <a class="op" href="subscribers.xml" target="_blank">
      <span class="xml-icon">XML</span>subscribers.xml<span class="op-tag-xml">subscribers.xsl</span></a>
    <a class="op" href="company.xml" target="_blank">
      <span class="xml-icon">XML</span>company.xml<span class="op-tag-xml">company.xsl</span></a>
  </div>

  <!-- Setup Steps -->
  <div class="card">
    <div class="ct">🔧 Setup (XAMPP)</div>
    <ul class="step-list">
      <li><div class="snum">1</div>
        <div class="sbody"><h4>Import Database</h4>
          <p>Open <code>localhost/phpmyadmin</code><br>
          Import <code>mtn_ghana.sql</code></p></div></li>
      <li><div class="snum">2</div>
        <div class="sbody"><h4>Enable cURL</h4>
          <p>Edit <code>C:\xampp\php\php.ini</code><br>
          Uncomment <code>extension=curl</code><br>
          Restart Apache</p></div></li>
      <li><div class="snum">3</div>
        <div class="sbody"><h4>Place Files</h4>
          <p>Copy all files to:<br>
          <code>C:\xampp\htdocs\REST_Web_Service\</code></p></div></li>
      <li><div class="snum">4</div>
        <div class="sbody"><h4>Open in Browser</h4>
          <p><code>localhost/REST_Web_Service/rest_client.php</code></p></div></li>
    </ul>
  </div>

  <!-- Architecture -->
  <div class="card">
    <div class="ct">🗺 Architecture</div>
    <div class="diag">
<span class="b">┌────────────────────────┐</span>
<span class="b">│  rest_client.php       │</span>
<span class="b">│  cURL + SimpleXML      │</span>
<span class="b">└──────────┬─────────────┘</span>
           <span class="y">│ HTTP GET/POST/PUT/DELETE</span>
           <span class="y">▼  ?r=employees&id=...</span>
<span class="y">┌────────────────────────┐</span>
<span class="y">│  rest_api.php          │</span>
<span class="y">│  Router + Handlers     │</span>
<span class="y">│  Returns XML document  │</span>
<span class="y">└──────────┬─────────────┘</span>
           <span class="y">│ PDO queries</span>
           <span class="y">▼</span>
<span class="r">┌────────────────────────┐</span>
<span class="r">│  MySQL · mtn_ghana     │</span>
<span class="r">│  employees             │</span>
<span class="r">│  products              │</span>
<span class="r">│  subscribers           │</span>
<span class="r">│  company_profile       │</span>
<span class="r">└────────────────────────┘</span>
           <span class="g">↕ static snapshots</span>
<span class="g">  employees.xml  → employees.xsl</span>
<span class="g">  products.xml   → products.xsl</span>
<span class="g">  subscribers.xml→ subscribers.xsl</span>
<span class="g">  company.xml    → company.xsl</span>
    </div>
  </div>
</div>

<!-- RIGHT PANEL -->
<div class="rpanel">

  <?php if ($error): ?>
  <div class="card">
    <div class="ct">❌ Error</div>
    <div class="errbox"><?= htmlspecialchars($error) ?></div>
  </div>

  <?php elseif ($result !== null): ?>
  <div class="meta">
    <span>Operation: <strong><?= htmlspecialchars($operation) ?></strong></span>
    <span>Method: <?= methodBadge($operations[$operation]['method']) ?></span>
    <?php if (!empty($_POST['param1']) && ($operations[$operation]['paramkey'] ?? '') !== ''): ?>
    <span><?= htmlspecialchars($operations[$operation]['paramkey']) ?>:
      <strong><?= htmlspecialchars($_POST['param1']) ?></strong></span>
    <?php endif; ?>
    <span>HTTP: <strong style="color:<?= $httpCode < 300 ? 'var(--green)' : 'var(--red)' ?>"><?= $httpCode ?></strong></span>
    <span>Time: <strong><?= $timeTaken ?>ms</strong></span>
    <span>Parser: <strong style="color:#79d4fd">SimpleXML</strong></span>
    <span>Format: <strong style="color:#79d4fd">XML</strong></span>
    <span>Status: <strong style="color:var(--green)">✓ SUCCESS</strong></span>
  </div>

  <div class="card">
    <div class="ct">📦 Response</div>
    <div class="tabs">
      <button class="tab active" onclick="showTab(this,'tab-data')">Parsed Data</button>
      <button class="tab" onclick="showTab(this,'tab-req')">Request Body</button>
      <button class="tab" onclick="showTab(this,'tab-res')">Raw XML</button>
    </div>
    <div id="tab-data">
      <?php
        $skip = ['status','code','timestamp'];
        foreach ($result->children() as $child):
            if (in_array($child->getName(), $skip, true)) continue;
            echo renderXML($child);
        endforeach;
      ?>
    </div>
    <div id="tab-req" style="display:none">
      <div class="xmlbox"><?= $rawReq !== ''
          ? htmlspecialchars($rawReq)
          : '<em style="color:var(--muted)">(no body — '
            . htmlspecialchars($operations[$operation]['method'])
            . ' request)</em>' ?></div>
    </div>
    <div id="tab-res" style="display:none">
      <div class="xmlbox"><?= prettyXML($rawRes) ?></div>
    </div>
  </div>

  <?php else: ?>
  <div class="card">
    <div class="empty">
      <div class="ico">🌐</div>
      <p><strong>Select a REST operation</strong> on the left<br>
      and click <em>Send REST Request</em>.<br><br>
      The server returns an <strong style="color:#79d4fd">XML document</strong>.<br>
      PHP's <code style="color:var(--y)">SimpleXML</code> parses it here.</p>
    </div>
  </div>
  <?php endif; ?>

  <!-- Quick Reference -->
  <div class="card">
    <div class="ct">📋 Sample Parameters</div>
    <table class="dump-table">
      <tr><td class="dk">getEmployee</td>
        <td class="dv"><code style="color:var(--y)">MTN-GH-0001</code> … <code style="color:var(--y)">MTN-GH-0009</code></td></tr>
      <tr><td class="dk">getEmployeesByDept</td>
        <td class="dv">
          <code style="color:var(--y)">Technology</code> | <code style="color:var(--y)">Finance</code> |
          <code style="color:var(--y)">Marketing</code> | <code style="color:var(--y)">Legal</code> |
          <code style="color:var(--y)">Human Resources</code> | <code style="color:var(--y)">Customer Care</code>
        </td></tr>
      <tr><td class="dk">getProduct</td>
        <td class="dv">
          <code style="color:var(--y)">MTN-DATA-01</code> | <code style="color:var(--y)">MTN-DATA-02</code> |
          <code style="color:var(--y)">MTN-DATA-03</code> | <code style="color:var(--y)">MTN-VOICE-01</code> |
          <code style="color:var(--y)">MTN-MOMO-01</code> | <code style="color:var(--y)">MTN-ROAM-01</code> |
          <code style="color:var(--y)">MTN-DEV-01</code>
        </td></tr>
      <tr><td class="dk">getProductsByCategory</td>
        <td class="dv">
          <code style="color:var(--y)">data</code> | <code style="color:var(--y)">voice</code> |
          <code style="color:var(--y)">momo</code> | <code style="color:var(--y)">roaming</code> |
          <code style="color:var(--y)">device</code>
        </td></tr>
      <tr><td class="dk">getSubscriber</td>
        <td class="dv">
          <code style="color:var(--y)">0244100001</code> | <code style="color:var(--y)">0554200002</code> |
          <code style="color:var(--y)">0244300003</code> | <code style="color:var(--y)">0594400004</code> |
          <code style="color:var(--y)">0244500005</code>
        </td></tr>
      <tr><td class="dk">getSubscribersByRegion</td>
        <td class="dv">
          <code style="color:var(--y)">Ashanti</code> | <code style="color:var(--y)">Greater Accra</code> |
          <code style="color:var(--y)">Western</code> | <code style="color:var(--y)">Central</code> |
          <code style="color:var(--y)">Eastern</code> | <code style="color:var(--y)">Volta</code>
        </td></tr>
      <tr><td class="dk">No params needed</td>
        <td class="dv"><em style="color:var(--muted)">getAllEmployees · getAllProducts · getAllSubscribers · getCompanyInfo</em></td></tr>
      <tr><td class="dk">XML / XSL Views</td>
        <td class="dv">
          <a href="employees.xml" target="_blank" style="color:#79d4fd;text-decoration:none">employees.xml</a> |
          <a href="products.xml" target="_blank" style="color:#79d4fd;text-decoration:none">products.xml</a> |
          <a href="subscribers.xml" target="_blank" style="color:#79d4fd;text-decoration:none">subscribers.xml</a> |
          <a href="company.xml" target="_blank" style="color:#79d4fd;text-decoration:none">company.xml</a>
        </td></tr>
    </table>
  </div>

</div><!-- /rpanel -->
</div><!-- /grid -->
</div><!-- /wrap -->

<script>
function selectOp(btn) {
  document.querySelectorAll('button.op').forEach(b => b.classList.remove('active'));
  btn.classList.add('active');
  document.getElementById('opInput').value = btn.dataset.op;

  const pBox = document.getElementById('paramBox');
  const pInp = document.getElementById('paramInput');
  const pLbl = document.getElementById('paramLabel');
  if (btn.dataset.hasparam === '1') {
    pBox.style.display = '';
    pLbl.textContent   = btn.dataset.paramname.replace(/_/g,' ');
    pInp.placeholder   = btn.dataset.paramph;
    pInp.value         = btn.dataset.paramph;
  } else {
    pBox.style.display = 'none';
    pInp.value = '';
  }

  const bBox = document.getElementById('bodyBox');
  const bInp = document.getElementById('bodyInput');
  if (btn.dataset.hasbody === '1') {
    bBox.style.display = '';
    bInp.value = btn.dataset.bodyph;
  } else {
    bBox.style.display = 'none';
    bInp.value = '';
  }

  document.getElementById('runBtn').disabled = false;
}

function showTab(btn, id) {
  document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
  btn.classList.add('active');
  ['tab-data','tab-req','tab-res'].forEach(t => {
    const el = document.getElementById(t);
    if (el) el.style.display = (t === id) ? '' : 'none';
  });
}
</script>
</body>
</html>
