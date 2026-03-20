<?xml version="1.0" encoding="UTF-8"?>
<!--
  ============================================================
  MTN GHANA – Company Profile XSL Stylesheet
  File    : company.xsl
  Path    : C:\xampp\htdocs\REST_Web_Service\company.xsl
  Paired  : company.xml
  Open    : company.xml in any modern browser
  ============================================================
-->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <xsl:template match="/company_profile">
    <html lang="en">
      <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>MTN Ghana – Company Profile</title>
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
          .hdr-in{max-width:900px;margin:0 auto;padding:16px 28px;
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
          .wrap{max-width:900px;margin:0 auto;padding:28px}
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
          .card{background:var(--card);border:1px solid var(--border);
                border-radius:var(--r);padding:24px;margin-bottom:22px}
          .ct{font-size:.68rem;font-weight:700;letter-spacing:1.5px;text-transform:uppercase;
              color:var(--y);margin-bottom:18px;padding-bottom:10px;
              border-bottom:1px solid var(--border)}

          /* Hero company card */
          .company-hero{background:linear-gradient(135deg,rgba(255,204,0,.08),rgba(255,153,0,.04));
                        border:1px solid rgba(255,204,0,.28);border-radius:var(--r);
                        padding:28px;margin-bottom:22px;display:flex;align-items:center;gap:24px}
          .company-logo{width:80px;height:80px;background:var(--dark);border:2px solid var(--y);
                        border-radius:50%;display:flex;align-items:center;justify-content:center;
                        font-weight:900;font-size:1.1rem;color:var(--y);letter-spacing:2px;flex-shrink:0}
          .company-info h2{font-size:1.6rem;font-weight:800;color:var(--y);margin-bottom:4px}
          .company-info .sub{font-size:.85rem;color:var(--muted)}
          .company-info .tags{display:flex;gap:8px;flex-wrap:wrap;margin-top:10px}
          .tag{padding:3px 12px;border-radius:20px;font-size:.72rem;font-weight:600}
          .tag-net{background:rgba(121,212,253,.15);color:#79d4fd}
          .tag-gse{background:rgba(0,200,81,.15);color:var(--green)}
          .tag-mtn{background:rgba(255,204,0,.15);color:var(--y)}

          /* KV table */
          .kv{width:100%;border-collapse:collapse;font-size:.85rem}
          .kv td.k{padding:12px 16px;background:rgba(255,204,0,.07);color:var(--y);
                   font-weight:600;border-bottom:1px solid rgba(255,255,255,.05);
                   white-space:nowrap;width:30%;vertical-align:middle}
          .kv td.v{padding:12px 16px;border-bottom:1px solid rgba(255,255,255,.05);
                   vertical-align:middle}
          .kv tr:last-child td{border-bottom:none}
          .kv tr:hover td{background:rgba(255,255,255,.02)}
          .v-link{color:#79d4fd;text-decoration:none}
          .v-link:hover{text-decoration:underline}

          /* Short codes grid */
          .codes-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(180px,1fr));gap:14px;margin-top:4px}
          .code-card{background:rgba(0,0,0,.25);border:1px solid var(--border);border-radius:8px;
                     padding:16px 18px;text-align:center}
          .code-val{font-family:'Courier New',monospace;font-size:1.4rem;font-weight:800;
                    color:var(--y);margin-bottom:6px}
          .code-svc{font-size:.72rem;color:var(--muted);text-transform:uppercase;letter-spacing:.8px}

          /* Founded timeline */
          .timeline{display:flex;align-items:center;gap:0;margin-top:4px}
          .tl-dot{width:14px;height:14px;border-radius:50%;background:var(--y);flex-shrink:0}
          .tl-line{flex:1;height:2px;background:linear-gradient(90deg,var(--y),rgba(255,204,0,.1))}
          .tl-now{font-size:.75rem;color:var(--muted);padding-left:10px;white-space:nowrap}

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
              <h1>MTN Ghana – Company Profile</h1>
              <p>XML Data Source · Transformed by company.xsl · mtn_ghana database</p>
            </div>
          </div>
        </div>

        <div class="sbar">
          <span><span class="dot dg"/>&#160;XML Source: company.xml</span>
          <span><span class="dot dg"/>&#160;Stylesheet: company.xsl</span>
          <span><span class="dot dy"/>&#160;Generated: <xsl:value-of select="@generated"/></span>
          <span><span class="dot dy"/>&#160;Source DB: <xsl:value-of select="@source"/></span>
        </div>

        <div class="wrap">
          <div class="nav">
            <span class="nav-divider">📂 XML Views:</span>
            <a href="employees.xml">👥 Employees</a>
            <a href="products.xml">📦 Products</a>
            <a href="subscribers.xml">📱 Subscribers</a>
            <a href="company.xml" class="active">🏢 Company</a>
          </div>
          <div class="nav-rest">
            <span class="nav-divider">🌐 REST System:</span>
            <a href="rest_client.php">⚡ REST Client Console</a>
            <a href="rest_api.php/employees">GET /employees</a>
            <a href="rest_api.php/products">GET /products</a>
            <a href="rest_api.php/subscribers">GET /subscribers</a>
            <a href="rest_api.php/company">GET /company</a>
          </div>

          <xsl:for-each select="company">

            <!-- Hero -->
            <div class="company-hero">
              <div class="company-logo">MTN</div>
              <div class="company-info">
                <h2><xsl:value-of select="company_name"/></h2>
                <div class="sub">Founded <xsl:value-of select="founded"/> · <xsl:value-of select="headquarters"/></div>
                <div class="tags">
                  <span class="tag tag-net"><xsl:value-of select="network_type"/></span>
                  <span class="tag tag-gse"><xsl:value-of select="stock_exchange"/></span>
                  <span class="tag tag-mtn"><xsl:value-of select="subscribers"/> subscribers</span>
                </div>
              </div>
            </div>

            <!-- Company Details KV -->
            <div class="card">
              <div class="ct">🏢 Company Details</div>
              <table class="kv">
                <tr>
                  <td class="k">Company Name</td>
                  <td class="v"><strong><xsl:value-of select="company_name"/></strong></td>
                </tr>
                <tr>
                  <td class="k">Founded</td>
                  <td class="v">
                    <xsl:value-of select="founded"/>
                    <div class="timeline" style="margin-top:8px">
                      <div class="tl-dot"></div>
                      <div class="tl-line"></div>
                      <div class="tl-now">2026 (32 years of operation)</div>
                    </div>
                  </td>
                </tr>
                <tr>
                  <td class="k">Headquarters</td>
                  <td class="v">📍 <xsl:value-of select="headquarters"/></td>
                </tr>
                <tr>
                  <td class="k">CEO</td>
                  <td class="v">👤 <xsl:value-of select="ceo"/></td>
                </tr>
                <tr>
                  <td class="k">Subscribers</td>
                  <td class="v"><strong style="color:var(--y)"><xsl:value-of select="subscribers"/></strong></td>
                </tr>
                <tr>
                  <td class="k">Network Type</td>
                  <td class="v"><span style="color:#79d4fd;font-weight:600"><xsl:value-of select="network_type"/></span></td>
                </tr>
                <tr>
                  <td class="k">MoMo Service</td>
                  <td class="v"><xsl:value-of select="momo_service"/></td>
                </tr>
                <tr>
                  <td class="k">Stock Exchange</td>
                  <td class="v"><span style="color:var(--green);font-weight:600"><xsl:value-of select="stock_exchange"/></span></td>
                </tr>
                <tr>
                  <td class="k">Parent Company</td>
                  <td class="v"><xsl:value-of select="parent_company"/></td>
                </tr>
                <tr>
                  <td class="k">Website</td>
                  <td class="v">
                    <a class="v-link">
                      <xsl:attribute name="href"><xsl:value-of select="website"/></xsl:attribute>
                      <xsl:attribute name="target">_blank</xsl:attribute>
                      <xsl:value-of select="website"/>
                    </a>
                  </td>
                </tr>
              </table>
            </div>

            <!-- Short Codes -->
            <div class="card">
              <div class="ct">📲 USSD Short Codes</div>
              <div class="codes-grid">
                <xsl:for-each select="short_codes/code">
                  <div class="code-card">
                    <div class="code-val"><xsl:value-of select="."/></div>
                    <div class="code-svc"><xsl:value-of select="translate(@service,'_',' ')"/></div>
                  </div>
                </xsl:for-each>
              </div>
            </div>

          </xsl:for-each>

          <!-- Raw XML preview -->
          <div class="card">
            <div class="ct">🔤 XML Source Preview (company.xml)</div>
            <div class="xmlbox">&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;?xml-stylesheet type="text/xsl" href="company.xsl"?&gt;
&lt;company_profile generated="2026-03-14" source="mtn_ghana.company_profile"&gt;

  &lt;company&gt;
    &lt;company_name&gt;MTN Ghana Limited&lt;/company_name&gt;
    &lt;founded&gt;1994&lt;/founded&gt;
    &lt;headquarters&gt;Accra, Greater Accra Region, Ghana&lt;/headquarters&gt;
    &lt;ceo&gt;Selorm Adadevoh&lt;/ceo&gt;
    &lt;subscribers&gt;28+ million&lt;/subscribers&gt;
    &lt;network_type&gt;4G LTE / 5G (pilot)&lt;/network_type&gt;
    &lt;short_codes&gt;
      &lt;code service="check_balance"&gt;*556#&lt;/code&gt;
      &lt;code service="data_bundle"&gt;*138#&lt;/code&gt;
      &lt;code service="momo"&gt;*170#&lt;/code&gt;
      &lt;code service="customer_care"&gt;100&lt;/code&gt;
    &lt;/short_codes&gt;
  &lt;/company&gt;

&lt;/company_profile&gt;</div>
          </div>

        </div>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
