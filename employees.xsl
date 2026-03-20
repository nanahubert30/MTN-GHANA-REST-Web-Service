<?xml version="1.0" encoding="UTF-8"?>
<!--
  ============================================================
  MTN GHANA – Employees XSL Stylesheet
  File    : employees.xsl
  Path    : C:\xampp\htdocs\REST_Web_Service\employees.xsl
  Paired  : employees.xml
  Open    : employees.xml in any modern browser
  ============================================================
-->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <!-- ═══════════════════════════════════ ROOT ═══════════════════════════════════ -->
  <xsl:template match="/employees">
    <html lang="en">
      <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>MTN Ghana – Employees</title>
        <style>
          *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
          :root{
            --y:#FFCC00;--yd:#e6b800;--dark:#1a1a2e;--mid:#16213e;
            --green:#00c851;--red:#e74c3c;--lt:#e8e8f0;
            --muted:#8888a0;--border:rgba(255,204,0,.18);
            --card:rgba(255,255,255,.04);--r:10px;
          }
          body{font-family:'Segoe UI',system-ui,sans-serif;
               background:var(--dark);color:var(--lt);min-height:100vh}

          /* ── Header ── */
          .hdr{background:linear-gradient(135deg,var(--y),#ff9900);
               box-shadow:0 4px 24px rgba(255,204,0,.25)}
          .hdr-in{max-width:1200px;margin:0 auto;padding:16px 28px;
                  display:flex;align-items:center;gap:16px}
          .logo{width:54px;height:54px;background:var(--dark);border-radius:50%;
                display:flex;align-items:center;justify-content:center;
                font-weight:900;font-size:13px;color:var(--y);letter-spacing:1px;
                flex-shrink:0}
          .hdr-text h1{color:var(--dark);font-size:1.5rem;font-weight:800}
          .hdr-text p{color:rgba(26,26,46,.7);font-size:.8rem;margin-top:2px}

          /* ── Status bar ── */
          .sbar{background:rgba(0,0,0,.4);border-bottom:1px solid var(--border);
                padding:7px 28px;display:flex;gap:24px;font-size:.75rem;
                color:var(--muted);overflow-x:auto}
          .sbar span{display:flex;align-items:center;gap:6px;white-space:nowrap}
          .dot{width:7px;height:7px;border-radius:50%;display:inline-block}
          .dg{background:var(--green);box-shadow:0 0 6px var(--green)}
          .dy{background:var(--y)}

          /* ── Layout ── */
          .wrap{max-width:1200px;margin:0 auto;padding:28px}

          /* ── Summary cards ── */
          .summary{display:grid;grid-template-columns:repeat(auto-fit,minmax(160px,1fr));
                   gap:16px;margin-bottom:28px}
          .sc{background:var(--card);border:1px solid var(--border);
              border-radius:var(--r);padding:18px 20px}
          .sc-val{font-size:2rem;font-weight:800;color:var(--y);line-height:1}
          .sc-lbl{font-size:.72rem;color:var(--muted);margin-top:4px;
                  text-transform:uppercase;letter-spacing:.8px}

          /* ── Card ── */
          .card{background:var(--card);border:1px solid var(--border);
                border-radius:var(--r);padding:24px;margin-bottom:22px}
          .ct{font-size:.68rem;font-weight:700;letter-spacing:1.5px;
              text-transform:uppercase;color:var(--y);margin-bottom:18px;
              padding-bottom:10px;border-bottom:1px solid var(--border);
              display:flex;align-items:center;gap:10px}
          .ct-badge{background:rgba(255,204,0,.18);color:var(--y);
                    padding:2px 10px;border-radius:20px;font-size:.7rem;font-weight:700}

          /* ── Table ── */
          .tbl{width:100%;border-collapse:collapse;font-size:.83rem}
          .tbl thead th{padding:10px 13px;background:rgba(255,204,0,.12);
                        color:var(--y);font-weight:700;text-align:left;
                        border-bottom:2px solid rgba(255,204,0,.3);
                        text-transform:uppercase;font-size:.68rem;letter-spacing:.8px;
                        white-space:nowrap}
          .tbl tbody td{padding:10px 13px;
                        border-bottom:1px solid rgba(255,255,255,.05);
                        vertical-align:middle}
          .tbl tbody tr:hover td{background:rgba(255,255,255,.03)}
          .tbl tbody tr:last-child td{border-bottom:none}

          /* ── Value styles ── */
          .v-id{color:#79d4fd;font-family:'Courier New',monospace;font-size:.8rem;
                font-weight:600}
          .v-name{font-weight:600}
          .v-dept{display:inline-block;padding:3px 10px;border-radius:20px;
                  font-size:.72rem;font-weight:600}
          .dept-Technology{background:rgba(121,212,253,.15);color:#79d4fd}
          .dept-Marketing{background:rgba(255,204,0,.15);color:var(--y)}
          .dept-Finance{background:rgba(0,200,81,.15);color:var(--green)}
          .dept-Legal{background:rgba(231,76,60,.15);color:var(--red)}
          .dept-Human-Resources{background:rgba(200,100,255,.15);color:#c864ff}
          .dept-Customer-Care{background:rgba(255,150,0,.15);color:#ff9600}
          .v-salary{color:#7ee8a2;font-family:'Courier New',monospace;font-weight:600}
          .v-date{color:var(--muted);font-size:.8rem}
          .v-email{color:var(--muted);font-size:.8rem}
          .badge-active{background:rgba(0,200,81,.15);color:var(--green);
                        border:1px solid rgba(0,200,81,.3);
                        padding:2px 9px;border-radius:20px;font-size:.7rem;font-weight:700}
          .badge-inactive{background:rgba(231,76,60,.15);color:var(--red);
                          border:1px solid rgba(231,76,60,.3);
                          padding:2px 9px;border-radius:20px;font-size:.7rem;font-weight:700}
          .badge-on_leave{background:rgba(255,204,0,.15);color:var(--y);
                          border:1px solid rgba(255,204,0,.3);
                          padding:2px 9px;border-radius:20px;font-size:.7rem;font-weight:700}

          /* ── Dept section headers ── */
          .dept-hdr{background:rgba(255,204,0,.06);border-left:3px solid var(--y);
                    padding:8px 14px;font-size:.72rem;font-weight:700;
                    letter-spacing:1px;text-transform:uppercase;color:var(--y);
                    margin-bottom:0}

          /* ── XML source box ── */
          .xmlbox{background:rgba(0,0,0,.35);border:1px solid var(--border);
                  border-radius:8px;padding:16px;overflow:auto;max-height:300px;
                  font-family:'Courier New',monospace;font-size:.72rem;
                  line-height:1.65;color:#c5cde8;white-space:pre}

          /* ── Nav links ── */
          .nav{display:flex;gap:10px;margin-bottom:10px;flex-wrap:wrap}
          .nav a{color:var(--y);font-size:.8rem;text-decoration:none;
                 padding:7px 16px;border:1px solid var(--border);border-radius:6px;
                 background:rgba(255,204,0,.05);transition:background .15s}
          .nav a:hover{background:rgba(255,204,0,.12)}
          .nav a.active{background:rgba(255,204,0,.18);border-color:var(--y)}
          /* ── REST API links bar ── */
          .api-nav{display:flex;gap:10px;margin-bottom:22px;flex-wrap:wrap}
          .api-nav a{font-size:.78rem;text-decoration:none;padding:6px 14px;
                     border-radius:6px;border:1px solid rgba(255,255,255,.1);
                     transition:background .15s}
          .api-nav a.rest{background:rgba(0,102,204,.15);color:#79d4fd;border-color:rgba(121,212,253,.25)}
          .api-nav a.rest:hover{background:rgba(0,102,204,.28)}
          .api-nav a.api{background:rgba(0,200,81,.1);color:var(--green);border-color:rgba(0,200,81,.25)}
          .api-nav a.api:hover{background:rgba(0,200,81,.2)}
          .api-nav .sep{color:var(--muted);font-size:.72rem;display:flex;align-items:center;
                        padding:0 4px;user-select:none}

          @media(max-width:900px){
            .tbl{font-size:.76rem}
            .tbl thead th,.tbl tbody td{padding:8px 9px}
          }
        </style>
      </head>
      <body>

        <!-- ── Header ── -->
        <div class="hdr">
          <div class="hdr-in">
            <div class="logo">MTN</div>
            <div class="hdr-text">
              <h1>MTN Ghana – Employee Directory</h1>
              <p>XML Data Source · Transformed by employees.xsl · mtn_ghana database</p>
            </div>
          </div>
        </div>

        <!-- ── Status bar ── -->
        <div class="sbar">
          <span><span class="dot dg"/>&#160;XML Source: employees.xml</span>
          <span><span class="dot dg"/>&#160;Stylesheet: employees.xsl</span>
          <span><span class="dot dy"/>&#160;Total Records: <strong style="color:var(--y)">&#160;<xsl:value-of select="@total"/></strong></span>
          <span><span class="dot dy"/>&#160;Generated: <xsl:value-of select="@generated"/></span>
          <span><span class="dot dy"/>&#160;Source DB: <xsl:value-of select="@source"/></span>
        </div>

        <div class="wrap">

          <!-- ── XML Data Nav ── -->
          <div class="nav">
            <a href="employees.xml" class="active">👥 Employees</a>
            <a href="products.xml">📦 Products</a>
            <a href="subscribers.xml">📱 Subscribers</a>
            <a href="company.xml">🏢 Company</a>
          </div>
          <!-- ── REST API Nav ── -->
          <div class="api-nav">
            <a href="rest_client.php" class="rest">🌐 REST Client Console</a>
            <span class="sep">·</span>
            <a href="rest_api.php/employees" class="api">⚡ GET /employees</a>
            <a href="rest_api.php/products" class="api">⚡ GET /products</a>
            <a href="rest_api.php/subscribers" class="api">⚡ GET /subscribers</a>
            <a href="rest_api.php/company" class="api">⚡ GET /company</a>
          </div>

          <!-- ── Summary cards ── -->
          <div class="summary">
            <div class="sc">
              <div class="sc-val"><xsl:value-of select="count(employee)"/></div>
              <div class="sc-lbl">Total Employees</div>
            </div>
            <div class="sc">
              <div class="sc-val"><xsl:value-of select="count(employee[department='Technology'])"/></div>
              <div class="sc-lbl">Technology</div>
            </div>
            <div class="sc">
              <div class="sc-val"><xsl:value-of select="count(employee[status='active'])"/></div>
              <div class="sc-lbl">Active Staff</div>
            </div>
            <div class="sc">
              <div class="sc-val">
                <!-- Count distinct departments using XSL 1.0 technique -->
                <xsl:value-of select="count(employee[not(department=preceding-sibling::employee/department)])"/>
              </div>
              <div class="sc-lbl">Departments</div>
            </div>
          </div>

          <!-- ── All Employees Table ── -->
          <div class="card">
            <div class="ct">
              👥 All Employees
              <span class="ct-badge"><xsl:value-of select="count(employee)"/> records</span>
            </div>
            <table class="tbl">
              <thead>
                <tr>
                  <th>#</th>
                  <th>Staff ID</th>
                  <th>Full Name</th>
                  <th>Department</th>
                  <th>Job Title</th>
                  <th>Email</th>
                  <th>Phone</th>
                  <th>Salary (GHS)</th>
                  <th>Hire Date</th>
                  <th>Status</th>
                </tr>
              </thead>
              <tbody>
                <xsl:for-each select="employee">
                  <xsl:sort select="department"/>
                  <xsl:sort select="full_name"/>
                  <tr>
                    <td><span class="v-date"><xsl:value-of select="id"/></span></td>
                    <td><span class="v-id"><xsl:value-of select="staff_id"/></span></td>
                    <td><span class="v-name"><xsl:value-of select="full_name"/></span></td>
                    <td>
                      <xsl:variable name="deptClass">
                        <xsl:value-of select="translate(department,' ','–')"/>
                      </xsl:variable>
                      <span>
                        <xsl:attribute name="class">v-dept dept-<xsl:value-of select="translate(department,' ','-')"/></xsl:attribute>
                        <xsl:value-of select="department"/>
                      </span>
                    </td>
                    <td><xsl:value-of select="job_title"/></td>
                    <td><span class="v-email"><xsl:value-of select="email"/></span></td>
                    <td><xsl:value-of select="phone"/></td>
                    <td><span class="v-salary">GHS&#160;<xsl:value-of select="format-number(salary_ghs,'#,##0.00')"/></span></td>
                    <td><span class="v-date"><xsl:value-of select="hire_date"/></span></td>
                    <td>
                      <xsl:choose>
                        <xsl:when test="status='active'">
                          <span class="badge-active">● active</span>
                        </xsl:when>
                        <xsl:when test="status='on_leave'">
                          <span class="badge-on_leave">◐ on leave</span>
                        </xsl:when>
                        <xsl:otherwise>
                          <span class="badge-inactive">○ inactive</span>
                        </xsl:otherwise>
                      </xsl:choose>
                    </td>
                  </tr>
                </xsl:for-each>
              </tbody>
            </table>
          </div>

          <!-- ── Technology Department ── -->
          <div class="card">
            <div class="ct">
              💻 Technology Department
              <span class="ct-badge"><xsl:value-of select="count(employee[department='Technology'])"/> staff</span>
            </div>
            <table class="tbl">
              <thead>
                <tr>
                  <th>Staff ID</th>
                  <th>Full Name</th>
                  <th>Job Title</th>
                  <th>Email</th>
                  <th>Salary (GHS)</th>
                  <th>Hire Date</th>
                </tr>
              </thead>
              <tbody>
                <xsl:for-each select="employee[department='Technology']">
                  <xsl:sort select="salary_ghs" order="descending" data-type="number"/>
                  <tr>
                    <td><span class="v-id"><xsl:value-of select="staff_id"/></span></td>
                    <td><span class="v-name"><xsl:value-of select="full_name"/></span></td>
                    <td><xsl:value-of select="job_title"/></td>
                    <td><span class="v-email"><xsl:value-of select="email"/></span></td>
                    <td><span class="v-salary">GHS&#160;<xsl:value-of select="format-number(salary_ghs,'#,##0.00')"/></span></td>
                    <td><span class="v-date"><xsl:value-of select="hire_date"/></span></td>
                  </tr>
                </xsl:for-each>
              </tbody>
            </table>
          </div>

          <!-- ── Top Earners ── -->
          <div class="card">
            <div class="ct">
              💰 Top 5 Earners (by Salary)
              <span class="ct-badge">sorted desc</span>
            </div>
            <table class="tbl">
              <thead>
                <tr>
                  <th>Rank</th>
                  <th>Staff ID</th>
                  <th>Full Name</th>
                  <th>Department</th>
                  <th>Job Title</th>
                  <th>Salary (GHS)</th>
                </tr>
              </thead>
              <tbody>
                <xsl:for-each select="employee">
                  <xsl:sort select="salary_ghs" order="descending" data-type="number"/>
                  <xsl:if test="position() &lt;= 5">
                    <tr>
                      <td><span class="v-id">#<xsl:value-of select="position()"/></span></td>
                      <td><span class="v-id"><xsl:value-of select="staff_id"/></span></td>
                      <td><span class="v-name"><xsl:value-of select="full_name"/></span></td>
                      <td>
                        <span>
                          <xsl:attribute name="class">v-dept dept-<xsl:value-of select="translate(department,' ','-')"/></xsl:attribute>
                          <xsl:value-of select="department"/>
                        </span>
                      </td>
                      <td><xsl:value-of select="job_title"/></td>
                      <td><span class="v-salary">GHS&#160;<xsl:value-of select="format-number(salary_ghs,'#,##0.00')"/></span></td>
                    </tr>
                  </xsl:if>
                </xsl:for-each>
              </tbody>
            </table>
          </div>

          <!-- ── Raw XML Source ── -->
          <div class="card">
            <div class="ct">🔤 XML Source Preview (employees.xml)</div>
            <p style="font-size:.76rem;color:var(--muted);margin-bottom:12px">
              Open <strong style="color:var(--y)">employees.xml</strong> directly in a browser — this XSL stylesheet is
              applied automatically via the <code style="color:var(--y)">&lt;?xml-stylesheet?&gt;</code> processing instruction.
            </p>
            <div class="xmlbox">&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;?xml-stylesheet type="text/xsl" href="employees.xsl"?&gt;
&lt;employees total="9" generated="2026-03-14" source="mtn_ghana.employees"&gt;

  &lt;employee&gt;
    &lt;id&gt;1&lt;/id&gt;
    &lt;staff_id&gt;MTN-GH-0001&lt;/staff_id&gt;
    &lt;full_name&gt;Kwame Mensah&lt;/full_name&gt;
    &lt;department&gt;Technology&lt;/department&gt;
    &lt;job_title&gt;Senior Software Engineer&lt;/job_title&gt;
    &lt;email&gt;k.mensah@mtn.com.gh&lt;/email&gt;
    &lt;salary_ghs&gt;8500.00&lt;/salary_ghs&gt;
    &lt;hire_date&gt;2019-03-15&lt;/hire_date&gt;
    &lt;status&gt;active&lt;/status&gt;
  &lt;/employee&gt;
  ...
&lt;/employees&gt;</div>
          </div>

        </div><!-- /wrap -->
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
