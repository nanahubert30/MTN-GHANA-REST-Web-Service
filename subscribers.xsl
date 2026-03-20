<?xml version="1.0" encoding="UTF-8"?>
<!--
  ============================================================
  MTN GHANA – Subscribers XSL Stylesheet
  File    : subscribers.xsl
  Path    : C:\xampp\htdocs\REST_Web_Service\subscribers.xsl
  Paired  : subscribers.xml
  Open    : subscribers.xml in any modern browser
  ============================================================
-->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <xsl:template match="/subscribers">
    <html lang="en">
      <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>MTN Ghana – Subscribers</title>
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
          .dg{background:var(--green);box-shadow:0 0 6px var(--green)}.dy{background:var(--y)}
          .wrap{max-width:1100px;margin:0 auto;padding:28px}
          .nav{display:flex;gap:10px;margin-bottom:8px;flex-wrap:wrap;align-items:center}
          .nav a{color:var(--y);font-size:.8rem;text-decoration:none;padding:7px 16px;
                 border:1px solid var(--border);border-radius:6px;background:rgba(255,204,0,.05)}
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
          .sc{background:var(--card);border:1px solid var(--border);border-radius:var(--r);padding:18px 20px}
          .sc-val{font-size:2rem;font-weight:800;color:var(--y);line-height:1}
          .sc-lbl{font-size:.72rem;color:var(--muted);margin-top:4px;text-transform:uppercase;letter-spacing:.8px}
          .card{background:var(--card);border:1px solid var(--border);
                border-radius:var(--r);padding:24px;margin-bottom:22px}
          .ct{font-size:.68rem;font-weight:700;letter-spacing:1.5px;text-transform:uppercase;
              color:var(--y);margin-bottom:18px;padding-bottom:10px;
              border-bottom:1px solid var(--border);display:flex;align-items:center;gap:10px}
          .ct-badge{background:rgba(255,204,0,.18);color:var(--y);
                    padding:2px 10px;border-radius:20px;font-size:.7rem;font-weight:700}
          .tbl{width:100%;border-collapse:collapse;font-size:.83rem}
          .tbl thead th{padding:10px 13px;background:rgba(255,204,0,.12);color:var(--y);
                        font-weight:700;text-align:left;border-bottom:2px solid rgba(255,204,0,.3);
                        text-transform:uppercase;font-size:.68rem;letter-spacing:.8px;white-space:nowrap}
          .tbl tbody td{padding:10px 13px;border-bottom:1px solid rgba(255,255,255,.05);vertical-align:middle}
          .tbl tbody tr:hover td{background:rgba(255,255,255,.03)}
          .tbl tbody tr:last-child td{border-bottom:none}
          .v-msisdn{color:#79d4fd;font-family:'Courier New',monospace;font-size:.82rem;font-weight:600}
          .v-name{font-weight:600}
          .v-date{color:var(--muted);font-size:.78rem}
          .badge-active{background:rgba(0,200,81,.15);color:var(--green);border:1px solid rgba(0,200,81,.3);
                        padding:2px 9px;border-radius:20px;font-size:.7rem;font-weight:700}
          .badge-suspended{background:rgba(231,76,60,.15);color:var(--red);border:1px solid rgba(231,76,60,.3);
                           padding:2px 9px;border-radius:20px;font-size:.7rem;font-weight:700}
          .badge-deactivated{background:rgba(136,136,160,.15);color:var(--muted);border:1px solid rgba(136,136,160,.3);
                             padding:2px 9px;border-radius:20px;font-size:.7rem;font-weight:700}
          .id-badge{display:inline-block;padding:2px 9px;border-radius:20px;font-size:.7rem;font-weight:600;
                    background:rgba(255,255,255,.07);color:var(--lt)}

          /* Region map – simple text badges */
          .region-badge{display:inline-block;padding:3px 9px;border-radius:20px;
                        font-size:.72rem;font-weight:600;
                        background:rgba(255,204,0,.09);color:var(--y)}

          /* Subscriber cards */
          .sgrid{display:grid;grid-template-columns:repeat(auto-fill,minmax(240px,1fr));gap:14px}
          .scard{background:rgba(255,255,255,.03);border:1px solid var(--border);
                 border-radius:var(--r);padding:18px;transition:border-color .18s}
          .scard:hover{border-color:rgba(255,204,0,.4)}
          .scard-msisdn{font-family:'Courier New',monospace;font-size:.85rem;
                        color:#79d4fd;font-weight:700;margin-bottom:6px}
          .scard-name{font-size:.95rem;font-weight:700;margin-bottom:4px}
          .scard-region{font-size:.78rem;color:var(--muted);margin-bottom:10px}
          .scard-footer{display:flex;align-items:center;justify-content:space-between;gap:6px;flex-wrap:wrap}

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
              <h1>MTN Ghana – Subscriber Registry</h1>
              <p>XML Data Source · Transformed by subscribers.xsl · mtn_ghana database</p>
            </div>
          </div>
        </div>

        <div class="sbar">
          <span><span class="dot dg"/>&#160;XML Source: subscribers.xml</span>
          <span><span class="dot dg"/>&#160;Stylesheet: subscribers.xsl</span>
          <span><span class="dot dy"/>&#160;Total: <strong style="color:var(--y)">&#160;<xsl:value-of select="@total"/></strong></span>
          <span><span class="dot dy"/>&#160;Generated: <xsl:value-of select="@generated"/></span>
          <span><span class="dot dy"/>&#160;Source DB: <xsl:value-of select="@source"/></span>
        </div>

        <div class="wrap">
          <div class="nav">
            <span class="nav-divider">📂 XML Views:</span>
            <a href="employees.xml">👥 Employees</a>
            <a href="products.xml">📦 Products</a>
            <a href="subscribers.xml" class="active">📱 Subscribers</a>
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
              <div class="sc-val"><xsl:value-of select="count(subscriber)"/></div>
              <div class="sc-lbl">Total Subscribers</div>
            </div>
            <div class="sc">
              <div class="sc-val"><xsl:value-of select="count(subscriber[status='active'])"/></div>
              <div class="sc-lbl">Active</div>
            </div>
            <div class="sc">
              <div class="sc-val">
                <xsl:value-of select="count(subscriber[not(region=preceding-sibling::subscriber/region)])"/>
              </div>
              <div class="sc-lbl">Regions</div>
            </div>
            <div class="sc">
              <div class="sc-val"><xsl:value-of select="count(subscriber[id_type='Ghana Card'])"/></div>
              <div class="sc-lbl">Ghana Card</div>
            </div>
          </div>

          <!-- Subscriber Cards -->
          <div class="card">
            <div class="ct">
              📱 All Subscribers – Card View
              <span class="ct-badge"><xsl:value-of select="count(subscriber)"/> records</span>
            </div>
            <div class="sgrid">
              <xsl:for-each select="subscriber">
                <xsl:sort select="full_name"/>
                <div class="scard">
                  <div class="scard-msisdn"><xsl:value-of select="msisdn"/></div>
                  <div class="scard-name"><xsl:value-of select="full_name"/></div>
                  <div class="scard-region">📍 <xsl:value-of select="region"/></div>
                  <div class="scard-footer">
                    <xsl:choose>
                      <xsl:when test="status='active'">
                        <span class="badge-active">● active</span>
                      </xsl:when>
                      <xsl:when test="status='suspended'">
                        <span class="badge-suspended">⊘ suspended</span>
                      </xsl:when>
                      <xsl:otherwise>
                        <span class="badge-deactivated">○ deactivated</span>
                      </xsl:otherwise>
                    </xsl:choose>
                    <span class="id-badge"><xsl:value-of select="id_type"/></span>
                  </div>
                </div>
              </xsl:for-each>
            </div>
          </div>

          <!-- Subscribers Table -->
          <div class="card">
            <div class="ct">
              📋 All Subscribers – Table View
              <span class="ct-badge">sorted A–Z</span>
            </div>
            <table class="tbl">
              <thead>
                <tr>
                  <th>#</th>
                  <th>MSISDN</th>
                  <th>Full Name</th>
                  <th>Region</th>
                  <th>ID Type</th>
                  <th>Status</th>
                  <th>Registered</th>
                </tr>
              </thead>
              <tbody>
                <xsl:for-each select="subscriber">
                  <xsl:sort select="full_name"/>
                  <tr>
                    <td><span style="color:var(--muted)"><xsl:value-of select="id"/></span></td>
                    <td><span class="v-msisdn"><xsl:value-of select="msisdn"/></span></td>
                    <td><span class="v-name"><xsl:value-of select="full_name"/></span></td>
                    <td><span class="region-badge"><xsl:value-of select="region"/></span></td>
                    <td><span class="id-badge"><xsl:value-of select="id_type"/></span></td>
                    <td>
                      <xsl:choose>
                        <xsl:when test="status='active'">
                          <span class="badge-active">● active</span>
                        </xsl:when>
                        <xsl:when test="status='suspended'">
                          <span class="badge-suspended">⊘ suspended</span>
                        </xsl:when>
                        <xsl:otherwise>
                          <span class="badge-deactivated">○ deactivated</span>
                        </xsl:otherwise>
                      </xsl:choose>
                    </td>
                    <td><span class="v-date"><xsl:value-of select="created_at"/></span></td>
                  </tr>
                </xsl:for-each>
              </tbody>
            </table>
          </div>

          <!-- Raw XML -->
          <div class="card">
            <div class="ct">🔤 XML Source Preview (subscribers.xml)</div>
            <div class="xmlbox">&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;?xml-stylesheet type="text/xsl" href="subscribers.xsl"?&gt;
&lt;subscribers total="6" generated="2026-03-14" source="mtn_ghana.subscribers"&gt;

  &lt;subscriber&gt;
    &lt;id&gt;1&lt;/id&gt;
    &lt;msisdn&gt;0244100001&lt;/msisdn&gt;
    &lt;full_name&gt;Esi Nyarko&lt;/full_name&gt;
    &lt;region&gt;Greater Accra&lt;/region&gt;
    &lt;id_type&gt;Ghana Card&lt;/id_type&gt;
    &lt;status&gt;active&lt;/status&gt;
    &lt;created_at&gt;2026-03-11 12:23:39&lt;/created_at&gt;
  &lt;/subscriber&gt;
  ...
&lt;/subscribers&gt;</div>
          </div>
        </div>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
