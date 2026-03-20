<?php
/**
 * ==========================================================
 *  MTN GHANA – REST Web Service  (XML + Database Edition)
 *  File : rest_api.php
 *  Path : C:\xampp\htdocs\soap_service\rest_api.php
 *  URL  : http://localhost/soap_service/rest_api.php
 * ==========================================================
 *  All responses are XML documents.
 *  Callers parse them with PHP SimpleXML.
 *  Routing uses simple ?r= query parameters — works on
 *  every XAMPP setup without PATH_INFO or .htaccess.
 *
 *  GET  rest_api.php?r=employees
 *  GET  rest_api.php?r=employees&id=MTN-GH-0001
 *  GET  rest_api.php?r=employees&dept=Technology
 *  POST rest_api.php?r=employees              (body: JSON)
 *  PUT  rest_api.php?r=employees&id=MTN-GH-0001
 *  DELETE rest_api.php?r=employees&id=MTN-GH-0001
 *
 *  GET  rest_api.php?r=products
 *  GET  rest_api.php?r=products&id=MTN-DATA-01
 *  GET  rest_api.php?r=products&category=data
 *  POST rest_api.php?r=products
 *  PUT  rest_api.php?r=products&id=MTN-DATA-01
 *  DELETE rest_api.php?r=products&id=MTN-DATA-01
 *
 *  GET  rest_api.php?r=subscribers
 *  GET  rest_api.php?r=subscribers&id=0244100001
 *  GET  rest_api.php?r=subscribers&region=Ashanti
 *  POST rest_api.php?r=subscribers
 *  PUT  rest_api.php?r=subscribers&id=0244100001
 *  DELETE rest_api.php?r=subscribers&id=0244100001
 *
 *  GET  rest_api.php?r=company
 * ==========================================================
 */

declare(strict_types=1);

header('Content-Type: application/xml; charset=UTF-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') { http_response_code(200); exit; }

// ── Database ───────────────────────────────────────────────
define('DB_HOST', 'localhost');
define('DB_NAME', 'mtn_ghana');
define('DB_USER', 'root');
define('DB_PASS', '');

function getDB(): PDO {
    static $pdo = null;
    if ($pdo === null) {
        $pdo = new PDO(
            'mysql:host=' . DB_HOST . ';dbname=' . DB_NAME . ';charset=utf8mb4',
            DB_USER, DB_PASS,
            [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
             PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC]
        );
    }
    return $pdo;
}

// ── XML Helpers ────────────────────────────────────────────
function xmlResponse(string $status, array $data, string $rootTag = 'data', int $code = 200): void {
    http_response_code($code);
    $doc = new DOMDocument('1.0', 'UTF-8');
    $doc->formatOutput = true;
    $root = $doc->createElement('response');
    $doc->appendChild($root);
    $root->appendChild($doc->createElement('status',    $status));
    $root->appendChild($doc->createElement('code',      (string)$code));
    $root->appendChild($doc->createElement('timestamp', date('Y-m-d H:i:s')));
    $dataEl = $doc->createElement($rootTag);
    $root->appendChild($dataEl);
    arrayToDOM($doc, $dataEl, $data);
    echo $doc->saveXML();
    exit;
}

function arrayToDOM(DOMDocument $doc, DOMElement $parent, array $arr): void {
    foreach ($arr as $key => $value) {
        $tag = is_int($key) ? singularise($parent->tagName) : safeTag((string)$key);
        if (is_array($value)) {
            $el = $doc->createElement($tag);
            $parent->appendChild($el);
            arrayToDOM($doc, $el, $value);
        } else {
            $el = $doc->createElement($tag);
            $el->appendChild($doc->createTextNode((string)($value ?? '')));
            $parent->appendChild($el);
        }
    }
}

function singularise(string $t): string {
    return ['employees'=>'employee','products'=>'product','subscribers'=>'subscriber'][$t] ?? rtrim($t,'s');
}

function safeTag(string $s): string {
    $s = preg_replace('/[^a-zA-Z0-9_\-.]/', '_', $s);
    if (preg_match('/^[0-9\-.]/', $s)) $s = '_'.$s;
    return $s ?: 'field';
}

function xmlError(string $msg, int $code = 400): void {
    xmlResponse('error', ['message' => $msg], 'error', $code);
}

// ── Request ────────────────────────────────────────────────
$method = $_SERVER['REQUEST_METHOD'];
$r      = trim($_GET['r']        ?? '');
$id     = trim($_GET['id']       ?? '');
$dept   = trim($_GET['dept']     ?? '');
$cat    = trim($_GET['category'] ?? '');
$region = trim($_GET['region']   ?? '');
$status = trim($_GET['status']   ?? '');

// Parse JSON body for POST / PUT
$body = [];
if (in_array($method, ['POST','PUT'], true)) {
    $raw  = file_get_contents('php://input');
    $body = json_decode($raw ?: '{}', true) ?? [];
    if (empty($body)) $body = $_POST; // fallback to form-encoded
}

if ($r === '') xmlError('Missing ?r= parameter. Valid: employees, products, subscribers, company', 400);

// ── Router ─────────────────────────────────────────────────
try {
    match($r) {
        'employees'   => handleEmployees($method, $id, $dept, $status, $body),
        'products'    => handleProducts($method, $id, $cat, $body),
        'subscribers' => handleSubscribers($method, $id, $region, $status, $body),
        'company'     => handleCompany($method),
        default       => xmlError("Unknown resource '$r'. Valid: employees, products, subscribers, company", 404),
    };
} catch (PDOException $e) {
    xmlError('Database error: ' . $e->getMessage(), 500);
} catch (Throwable $e) {
    xmlError('Server error: ' . $e->getMessage(), 500);
}

// ═══════════════════════════════════════════════════════════
//  EMPLOYEES
// ═══════════════════════════════════════════════════════════
function handleEmployees(string $method, string $id, string $dept, string $status, array $body): void {

    // GET single employee
    if ($method === 'GET' && $id !== '') {
        $st = getDB()->prepare('SELECT * FROM employees WHERE staff_id = ?');
        $st->execute([$id]);
        $row = $st->fetch();
        if (!$row) xmlError("Employee '$id' not found", 404);
        xmlResponse('success', $row, 'employee');
    }

    // GET by department
    if ($method === 'GET' && $dept !== '') {
        $st = getDB()->prepare('SELECT * FROM employees WHERE department = ? ORDER BY full_name');
        $st->execute([$dept]);
        $rows = $st->fetchAll();
        if (empty($rows)) xmlError("No employees found in department '$dept'", 404);
        xmlResponse('success', ['department'=>$dept,'count'=>(string)count($rows),'employees'=>$rows], 'data');
    }

    // GET all (optional status filter)
    if ($method === 'GET') {
        $sql = 'SELECT * FROM employees WHERE 1=1';
        $params = [];
        if ($status !== '') { $sql .= ' AND status = ?'; $params[] = $status; }
        $sql .= ' ORDER BY department, full_name';
        $st = getDB()->prepare($sql);
        $st->execute($params);
        $rows = $st->fetchAll();
        xmlResponse('success', ['count'=>(string)count($rows),'employees'=>$rows], 'data');
    }

    // POST create
    if ($method === 'POST') {
        foreach (['staff_id','full_name','department','job_title','email','phone','salary_ghs','hire_date'] as $f)
            if (empty($body[$f])) xmlError("Missing required field: $f", 422);
        getDB()->prepare('INSERT INTO employees (staff_id,full_name,department,job_title,email,phone,salary_ghs,hire_date) VALUES (?,?,?,?,?,?,?,?)')
            ->execute([$body['staff_id'],$body['full_name'],$body['department'],$body['job_title'],$body['email'],$body['phone'],$body['salary_ghs'],$body['hire_date']]);
        $st = getDB()->prepare('SELECT * FROM employees WHERE staff_id = ?');
        $st->execute([$body['staff_id']]);
        xmlResponse('success', array_merge(['message'=>'Employee created successfully'], $st->fetch()), 'employee', 201);
    }

    // PUT update
    if ($method === 'PUT' && $id !== '') {
        $allowed = ['full_name','department','job_title','email','phone','salary_ghs','hire_date','status'];
        $sets = []; $params = [];
        foreach ($allowed as $f) if (isset($body[$f])) { $sets[] = "$f = ?"; $params[] = $body[$f]; }
        if (empty($sets)) xmlError('No valid fields to update', 422);
        $params[] = $id;
        getDB()->prepare('UPDATE employees SET '.implode(', ',$sets).' WHERE staff_id = ?')->execute($params);
        $st = getDB()->prepare('SELECT * FROM employees WHERE staff_id = ?');
        $st->execute([$id]);
        $row = $st->fetch();
        if (!$row) xmlError("Employee '$id' not found", 404);
        xmlResponse('success', array_merge(['message'=>'Employee updated successfully'], $row), 'employee');
    }

    // DELETE
    if ($method === 'DELETE' && $id !== '') {
        $st = getDB()->prepare('SELECT staff_id, full_name FROM employees WHERE staff_id = ?');
        $st->execute([$id]);
        $row = $st->fetch();
        if (!$row) xmlError("Employee '$id' not found", 404);
        getDB()->prepare('DELETE FROM employees WHERE staff_id = ?')->execute([$id]);
        xmlResponse('success', ['message'=>"Employee '$id' deleted",'staff_id'=>$id,'name'=>$row['full_name']], 'result');
    }

    xmlError("Method $method not allowed for /employees", 405);
}

// ═══════════════════════════════════════════════════════════
//  PRODUCTS
// ═══════════════════════════════════════════════════════════
function handleProducts(string $method, string $id, string $cat, array $body): void {

    // GET single product
    if ($method === 'GET' && $id !== '') {
        $st = getDB()->prepare('SELECT * FROM products WHERE product_code = ?');
        $st->execute([$id]);
        $row = $st->fetch();
        if (!$row) xmlError("Product '$id' not found", 404);
        xmlResponse('success', $row, 'product');
    }

    // GET by category
    if ($method === 'GET' && $cat !== '') {
        $st = getDB()->prepare('SELECT * FROM products WHERE category = ? AND is_active = 1 ORDER BY product_name');
        $st->execute([$cat]);
        $rows = $st->fetchAll();
        if (empty($rows)) xmlError("No products found in category '$cat'", 404);
        xmlResponse('success', ['category'=>$cat,'count'=>(string)count($rows),'products'=>$rows], 'data');
    }

    // GET all
    if ($method === 'GET') {
        $st = getDB()->query('SELECT * FROM products WHERE is_active = 1 ORDER BY category, product_name');
        $rows = $st->fetchAll();
        xmlResponse('success', ['count'=>(string)count($rows),'products'=>$rows], 'data');
    }

    // POST create
    if ($method === 'POST') {
        foreach (['product_code','product_name','category','price_ghs'] as $f)
            if (empty($body[$f])) xmlError("Missing required field: $f", 422);
        getDB()->prepare('INSERT INTO products (product_code,product_name,category,price_ghs,description) VALUES (?,?,?,?,?)')
            ->execute([$body['product_code'],$body['product_name'],$body['category'],$body['price_ghs'],$body['description']??null]);
        $st = getDB()->prepare('SELECT * FROM products WHERE product_code = ?');
        $st->execute([$body['product_code']]);
        xmlResponse('success', array_merge(['message'=>'Product created successfully'], $st->fetch()), 'product', 201);
    }

    // PUT update
    if ($method === 'PUT' && $id !== '') {
        $allowed = ['product_name','category','price_ghs','description','is_active'];
        $sets = []; $params = [];
        foreach ($allowed as $f) if (isset($body[$f])) { $sets[] = "$f = ?"; $params[] = $body[$f]; }
        if (empty($sets)) xmlError('No valid fields to update', 422);
        $params[] = $id;
        getDB()->prepare('UPDATE products SET '.implode(', ',$sets).' WHERE product_code = ?')->execute($params);
        $st = getDB()->prepare('SELECT * FROM products WHERE product_code = ?');
        $st->execute([$id]);
        $row = $st->fetch();
        if (!$row) xmlError("Product '$id' not found", 404);
        xmlResponse('success', array_merge(['message'=>'Product updated successfully'], $row), 'product');
    }

    // DELETE
    if ($method === 'DELETE' && $id !== '') {
        $st = getDB()->prepare('SELECT product_code, product_name FROM products WHERE product_code = ?');
        $st->execute([$id]);
        $row = $st->fetch();
        if (!$row) xmlError("Product '$id' not found", 404);
        getDB()->prepare('DELETE FROM products WHERE product_code = ?')->execute([$id]);
        xmlResponse('success', ['message'=>"Product '$id' deleted",'product_code'=>$id,'name'=>$row['product_name']], 'result');
    }

    xmlError("Method $method not allowed for /products", 405);
}

// ═══════════════════════════════════════════════════════════
//  SUBSCRIBERS
// ═══════════════════════════════════════════════════════════
function handleSubscribers(string $method, string $id, string $region, string $status, array $body): void {

    // GET single subscriber
    if ($method === 'GET' && $id !== '') {
        $st = getDB()->prepare('SELECT * FROM subscribers WHERE msisdn = ?');
        $st->execute([$id]);
        $row = $st->fetch();
        if (!$row) xmlError("Subscriber '$id' not found", 404);
        xmlResponse('success', $row, 'subscriber');
    }

    // GET by region
    if ($method === 'GET' && $region !== '') {
        $st = getDB()->prepare('SELECT * FROM subscribers WHERE region = ? ORDER BY full_name');
        $st->execute([$region]);
        $rows = $st->fetchAll();
        if (empty($rows)) xmlError("No subscribers found in region '$region'", 404);
        xmlResponse('success', ['region'=>$region,'count'=>(string)count($rows),'subscribers'=>$rows], 'data');
    }

    // GET all (optional status filter)
    if ($method === 'GET') {
        $sql = 'SELECT * FROM subscribers WHERE 1=1';
        $params = [];
        if ($status !== '') { $sql .= ' AND status = ?'; $params[] = $status; }
        $sql .= ' ORDER BY full_name';
        $st = getDB()->prepare($sql);
        $st->execute($params);
        $rows = $st->fetchAll();
        xmlResponse('success', ['count'=>(string)count($rows),'subscribers'=>$rows], 'data');
    }

    // POST create
    if ($method === 'POST') {
        foreach (['msisdn','full_name','region'] as $f)
            if (empty($body[$f])) xmlError("Missing required field: $f", 422);
        getDB()->prepare('INSERT INTO subscribers (msisdn,full_name,region,id_type) VALUES (?,?,?,?)')
            ->execute([$body['msisdn'],$body['full_name'],$body['region'],$body['id_type']??'Ghana Card']);
        $st = getDB()->prepare('SELECT * FROM subscribers WHERE msisdn = ?');
        $st->execute([$body['msisdn']]);
        xmlResponse('success', array_merge(['message'=>'Subscriber created successfully'], $st->fetch()), 'subscriber', 201);
    }

    // PUT update
    if ($method === 'PUT' && $id !== '') {
        $allowed = ['full_name','region','id_type','status'];
        $sets = []; $params = [];
        foreach ($allowed as $f) if (isset($body[$f])) { $sets[] = "$f = ?"; $params[] = $body[$f]; }
        if (empty($sets)) xmlError('No valid fields to update', 422);
        $params[] = $id;
        getDB()->prepare('UPDATE subscribers SET '.implode(', ',$sets).' WHERE msisdn = ?')->execute($params);
        $st = getDB()->prepare('SELECT * FROM subscribers WHERE msisdn = ?');
        $st->execute([$id]);
        $row = $st->fetch();
        if (!$row) xmlError("Subscriber '$id' not found", 404);
        xmlResponse('success', array_merge(['message'=>'Subscriber updated successfully'], $row), 'subscriber');
    }

    // DELETE
    if ($method === 'DELETE' && $id !== '') {
        $st = getDB()->prepare('SELECT msisdn, full_name FROM subscribers WHERE msisdn = ?');
        $st->execute([$id]);
        $row = $st->fetch();
        if (!$row) xmlError("Subscriber '$id' not found", 404);
        getDB()->prepare('DELETE FROM subscribers WHERE msisdn = ?')->execute([$id]);
        xmlResponse('success', ['message'=>"Subscriber '$id' deleted",'msisdn'=>$id,'name'=>$row['full_name']], 'result');
    }

    xmlError("Method $method not allowed for /subscribers", 405);
}

// ═══════════════════════════════════════════════════════════
//  COMPANY
// ═══════════════════════════════════════════════════════════
function handleCompany(string $method): void {
    if ($method !== 'GET') xmlError('Only GET is supported for company', 405);
    $row = getDB()->query('SELECT * FROM company_profile ORDER BY id ASC LIMIT 1')->fetch();
    if (!$row) xmlError('Company profile not found in database', 404);
    $shortCodes = [];
    foreach (json_decode($row['short_codes_json'] ?? '{}', true) as $svc => $code)
        $shortCodes[] = ['service'=>$svc,'code'=>$code];
    xmlResponse('success', [
        'company_name'   => $row['company_name'],
        'founded'        => $row['founded'],
        'headquarters'   => $row['headquarters'],
        'ceo'            => $row['ceo'],
        'subscribers'    => $row['subscribers'],
        'network_type'   => $row['network_type'],
        'momo_service'   => $row['momo_service'],
        'stock_exchange' => $row['stock_exchange'],
        'parent_company' => $row['parent_company'],
        'website'        => $row['website'],
        'short_codes'    => $shortCodes,
    ], 'company');
}
