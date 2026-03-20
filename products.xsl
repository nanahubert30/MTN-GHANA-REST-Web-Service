<?xml version="1.0" encoding="UTF-8"?>
<!--
  ============================================================
  MTN GHANA – Products XSL Stylesheet
  File    : products.xsl
  Path    : C:\xampp\htdocs\soap_service\products.xsl
  Paired  : products.xml
  Open    : products.xml in any modern browser
  ============================================================
-->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <xsl:template match="/products">
    <html lang="en">
      <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>MTN Ghana – Products</title>
        <style>
          *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
          :root{
            --y:#FFCC00;--dark:#1a1a2e;--green:#00c851;--red:#e74c3c;
            --lt:#e8e8f0;--muted:#8888a0;--border:rgba(255,204,0,.18);
            --card:rgba(255,255,255,.04);--r:10px;
          }
          body{font-family:'Segoe UI',system-ui,sans-serif;
               background:var(--dark);color:var(--lt);min-height:100vh}
          .hdr{background:linear-gradient(135deg,var(--y),#ff9900);
               box-shadow:0 4px 24px rgba(255,204,0,.25)}
          .hdr-in{max-width:1100px;margin:0 auto;padding:16px 28px;
                  display:flex;align-items:center;gap:16px}
          .logo{width:54px;height:54px;background:var(--dark);border-radius:50%;
                display:flex;align-items:center;justify-content:center;
                font-weight:900;font-size:13px;color:var(--y);letter-spacing:1px;flex-shrink:0}
          .hdr-text h1{color:var(--dark);font-size:1.5rem;font-weight:800}
          .hdr-text p{color:rgba(26,26,46,.7);font-size:.8rem;margin-top:2px}
          .sbar{background:rgba(0,0,0,.4);border-bottom:1px solid var(--border);
                padding:7px 28px;display:flex;gap:24px;font-size:.75rem;
                color:var(--muted);overflow-x:auto}
          .sbar span{display:flex;align-items:center;gap:6px;white-space:nowrap}
          .dot{width:7px;height:7px;border-radius:50%;display:inline-block}
          .dg{background:var(--green);box-shadow:0 0 6px var(--green)}
          .dy{background:var(--y)}
          .wrap{max-width:1100px;margin:0 auto;padding:28px}
          .nav{display:flex;gap:10px;margin-bottom:8px;flex-wrap:wrap;align-items:center}
          .nav a{color:var(--y);font-size:.8rem;text-decoration:none;
                 padding:7px 16px;border:1px solid var(--border);border-radius:6px;
                 background:rgba(255,204,0,.05)}
          .nav a:hover{background:rgba(255,204,0,.12)}
          .nav a.active{background:rgba(255,204,0,.18);border-color:var(--y)}
          .nav-rest{display:flex;gap:10px;margin-bottom:22px;flex-wrap:wrap;align-items:center}
          .nav-rest a{color:#79d4fd;font-size:.78rem;text-decoration:none;
                      padding:6px 14px;border:1px solid rgba(121,212,253,.2);border-radius:6px;
                      background:rgba(121,212,253,.05)}
          .nav-rest a:hover{background:rgba(121,212,253,.12);border-color:rgba(121,212,253,.5)}
          .nav-divider{font-size:.68rem;color:var(--muted);padding:0 4px;white-space:nowrap}
          .summary{display:grid;grid-template-columns:repeat(auto-fit,minmax(150px,1fr));
                   gap:16px;margin-bottom:28px}
          .sc{background:var(--card);border:1px solid var(--border);
              border-radius:var(--r);padding:18px 20px}
          .sc-val{font-size:2rem;font-weight:800;color:var(--y);line-height:1}
          .sc-lbl{font-size:.72rem;color:var(--muted);margin-top:4px;
                  text-transform:uppercase;letter-spacing:.8px}
          .card{background:var(--card);border:1px solid var(--border);
                border-radius:var(--r);padding:24px;margin-bottom:22px}
          .ct{font-size:.68rem;font-weight:700;letter-spacing:1.5px;text-transform:uppercase;
              color:var(--y);margin-bottom:18px;padding-bottom:10px;
              border-bottom:1px solid var(--border);display:flex;align-items:center;gap:10px}
          .ct-badge{background:rgba(255,204,0,.18);color:var(--y);
                    padding:2px 10px;border-radius:20px;font-size:.7rem;font-weight:700}

          /* Product cards grid */
          .pgrid{display:grid;grid-template-columns:repeat(auto-fill,minmax(260px,1fr));gap:16px}
          .pcard{background:rgba(255,255,255,.03);border:1px solid var(--border);
                 border-radius:var(--r);padding:20px;transition:border-color .18s}
          .pcard:hover{border-color:rgba(255,204,0,.45)}
          .pcard-code{font-family:'Courier New',monospace;font-size:.75rem;
                      color:#79d4fd;margin-bottom:8px}
          .pcard-name{font-size:1rem;font-weight:700;margin-bottom:8px}
          .pcard-desc{font-size:.8rem;color:var(--muted);margin-bottom:14px;line-height:1.5}
          .pcard-footer{display:flex;align-items:center;justify-content:space-between;
                        margin-top:auto}
          .pcard-price{font-size:1.3rem;font-weight:800;color:#7ee8a2}
          .pcard-price span{font-size:.7rem;color:var(--muted);font-weight:400}
          .cat-badge{padding:3px 10px;border-radius:20px;font-size:.68rem;font-weight:700}
          .cat-voice   {background:rgba(0,200,81,.15);  color:var(--green)}
          .cat-data    {background:rgba(121,212,253,.15);color:#79d4fd}
          .cat-momo    {background:rgba(255,204,0,.15);  color:var(--y)}
          .cat-roaming {background:rgba(255,150,0,.15);  color:#ff9600}
          .cat-device  {background:rgba(200,100,255,.15);color:#c864ff}

          /* Table variant */
          .tbl{width:100%;border-collapse:collapse;font-size:.83rem}
          .tbl thead th{padding:10px 13px;background:rgba(255,204,0,.12);color:var(--y);
                        font-weight:700;text-align:left;border-bottom:2px solid rgba(255,204,0,.3);
                        text-transform:uppercase;font-size:.68rem;letter-spacing:.8px}
          .tbl tbody td{padding:10px 13px;border-bottom:1px solid rgba(255,255,255,.05);vertical-align:middle}
          .tbl tbody tr:hover td{background:rgba(255,255,255,.03)}
          .tbl tbody tr:last-child td{border-bottom:none}
          .v-id{color:#79d4fd;font-family:'Courier New',monospace;font-size:.8rem;font-weight:600}
          .v-price{color:#7ee8a2;font-family:'Courier New',monospace;font-weight:600}
          .v-free{color:var(--y);font-weight:700}
          .xmlbox{background:rgba(0,0,0,.35);border:1px solid var(--border);border-radius:8px;
                  padding:16px;overflow:auto;max-height:280px;
                  font-family:'Courier New',monospace;font-size:.72rem;
                  line-height:1.65;color:#c5cde8;white-space:pre}
        </style>
      </head>
      <body>

        <div class="hdr">
          <div class="hdr-in">
            <div class="logo">MTN</div>
            <div class="hdr-text">
              <h1>MTN Ghana – Product Catalogue</h1>
              <p>XML Data Source · Transformed by products.xsl · mtn_ghana database</p>
            </div>
          </div>
        </div>

        <div class="sbar">
          <span><span class="dot dg"/>&#160;XML Source: products.xml</span>
          <span><span class="dot dg"/>&#160;Stylesheet: products.xsl</span>
          <span><span class="dot dy"/>&#160;Total Products: <strong style="color:var(--y)">&#160;<xsl:value-of select="@total"/></strong></span>
          <span><span class="dot dy"/>&#160;Generated: <xsl:value-of select="@generated"/></span>
          <span><span class="dot dy"/>&#160;Source DB: <xsl:value-of select="@source"/></span>
        </div>

        <div class="wrap">
          <div class="nav">
            <span class="nav-divider">📂 XML Views:</span>
            <a href="employees.xml">👥 Employees</a>
            <a href="products.xml" class="active">📦 Products</a>
            <a href="subscribers.xml">📱 Subscribers</a>
            <a href="company.xml">🏢 Company</a>
          </div>
          <div class="nav-rest">
            <span class="nav-divider">🌐 REST System:</span>
            <a href="rest_client.php">⚡ REST Client Console</a>
            <a href="rest_api.php/employees">GET /employees</a>
            <a href="rest_api.php/products">GET /products</a>
            <a href="rest_api.php/subscribers">GET /subscribers</a>
            <a href="rest_api.php/company">GET /company</a>
          </div>

          <!-- Summary -->
          <div class="summary">
            <div class="sc">
              <div class="sc-val"><xsl:value-of select="count(product)"/></div>
              <div class="sc-lbl">Total Products</div>
            </div>
            <div class="sc">
              <div class="sc-val"><xsl:value-of select="count(product[category='data'])"/></div>
              <div class="sc-lbl">Data Plans</div>
            </div>
            <div class="sc">
              <div class="sc-val"><xsl:value-of select="count(product[is_active='1'])"/></div>
              <div class="sc-lbl">Active</div>
            </div>
            <div class="sc">
              <div class="sc-val"><xsl:value-of select="count(product[price_ghs='0.00'])"/></div>
              <div class="sc-lbl">Free Products</div>
            </div>
          </div>

          <!-- Product Cards -->
          <div class="card">
            <div class="ct">
              📦 All Products – Card View
              <span class="ct-badge"><xsl:value-of select="count(product)"/> products</span>
            </div>
            <div class="pgrid">
              <xsl:for-each select="product">
                <xsl:sort select="category"/>
                <div class="pcard">
                  <div class="pcard-code"><xsl:value-of select="product_code"/></div>
                  <div class="pcard-name"><xsl:value-of select="product_name"/></div>
                  <div class="pcard-desc"><xsl:value-of select="description"/></div>
                  <div class="pcard-footer">
                    <div class="pcard-price">
                      <xsl:choose>
                        <xsl:when test="price_ghs = '0.00'">
                          <span class="v-free">FREE</span>
                        </xsl:when>
                        <xsl:otherwise>
                          GHS&#160;<xsl:value-of select="format-number(price_ghs,'#,##0.00')"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </div>
                    <span>
                      <xsl:attribute name="class">cat-badge cat-<xsl:value-of select="category"/></xsl:attribute>
                      <xsl:value-of select="category"/>
                    </span>
                  </div>
                </div>
              </xsl:for-each>
            </div>
          </div>

          <!-- Products Table -->
          <div class="card">
            <div class="ct">
              📋 Products – Table View
              <span class="ct-badge">sorted by price</span>
            </div>
            <table class="tbl">
              <thead>
                <tr>
                  <th>#</th>
                  <th>Product Code</th>
                  <th>Product Name</th>
                  <th>Category</th>
                  <th>Price (GHS)</th>
                  <th>Description</th>
                  <th>Active</th>
                </tr>
              </thead>
              <tbody>
                <xsl:for-each select="product">
                  <xsl:sort select="price_ghs" data-type="number" order="ascending"/>
                  <tr>
                    <td><span style="color:var(--muted)"><xsl:value-of select="id"/></span></td>
                    <td><span class="v-id"><xsl:value-of select="product_code"/></span></td>
                    <td><strong><xsl:value-of select="product_name"/></strong></td>
                    <td>
                      <span>
                        <xsl:attribute name="class">cat-badge cat-<xsl:value-of select="category"/></xsl:attribute>
                        <xsl:value-of select="category"/>
                      </span>
                    </td>
                    <td>
                      <xsl:choose>
                        <xsl:when test="price_ghs = '0.00'">
                          <span class="v-free">FREE</span>
                        </xsl:when>
                        <xsl:otherwise>
                          <span class="v-price">GHS&#160;<xsl:value-of select="format-number(price_ghs,'#,##0.00')"/></span>
                        </xsl:otherwise>
                      </xsl:choose>
                    </td>
                    <td style="color:var(--muted);font-size:.8rem"><xsl:value-of select="description"/></td>
                    <td>
                      <xsl:choose>
                        <xsl:when test="is_active='1'">
                          <span style="color:var(--green);font-weight:700;font-size:.75rem">● Yes</span>
                        </xsl:when>
                        <xsl:otherwise>
                          <span style="color:var(--red);font-weight:700;font-size:.75rem">○ No</span>
                        </xsl:otherwise>
                      </xsl:choose>
                    </td>
                  </tr>
                </xsl:for-each>
              </tbody>
            </table>
          </div>

          <!-- Data Plans only -->
          <div class="card">
            <div class="ct">
              📶 Data Plans Only
              <span class="ct-badge"><xsl:value-of select="count(product[category='data'])"/> plans</span>
            </div>
            <table class="tbl">
              <thead>
                <tr>
                  <th>Code</th>
                  <th>Plan Name</th>
                  <th>Price (GHS)</th>
                  <th>Details</th>
                </tr>
              </thead>
              <tbody>
                <xsl:for-each select="product[category='data']">
                  <xsl:sort select="price_ghs" data-type="number"/>
                  <tr>
                    <td><span class="v-id"><xsl:value-of select="product_code"/></span></td>
                    <td><strong><xsl:value-of select="product_name"/></strong></td>
                    <td><span class="v-price">GHS&#160;<xsl:value-of select="format-number(price_ghs,'#,##0.00')"/></span></td>
                    <td style="color:var(--muted);font-size:.8rem"><xsl:value-of select="description"/></td>
                  </tr>
                </xsl:for-each>
              </tbody>
            </table>
          </div>

          <!-- Raw XML preview -->
          <div class="card">
            <div class="ct">🔤 XML Source Preview (products.xml)</div>
            <div class="xmlbox">&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;?xml-stylesheet type="text/xsl" href="products.xsl"?&gt;
&lt;products total="7" generated="2026-03-14" source="mtn_ghana.products"&gt;

  &lt;product&gt;
    &lt;id&gt;2&lt;/id&gt;
    &lt;product_code&gt;MTN-DATA-01&lt;/product_code&gt;
    &lt;product_name&gt;MTN Daily 1GB&lt;/product_name&gt;
    &lt;category&gt;data&lt;/category&gt;
    &lt;price_ghs&gt;3.00&lt;/price_ghs&gt;
    &lt;description&gt;1 GB data – valid 24 hours&lt;/description&gt;
    &lt;is_active&gt;1&lt;/is_active&gt;
  &lt;/product&gt;
  ...
&lt;/products&gt;</div>
          </div>

        </div>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
