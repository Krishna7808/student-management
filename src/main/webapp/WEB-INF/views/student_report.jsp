<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Academic Report Card | ${s.name}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body { background-color: #f8f9fa; font-family: 'Segoe UI', sans-serif; }
        .report-container { max-width: 960px; margin: 40px auto; }
        .report-card { background: white; border: 2px solid #2c3e50; box-shadow: 0 10px 30px rgba(0,0,0,0.1); }
        .header-banner { background: #2c3e50; color: white; padding: 36px; text-align: center; }
        .student-meta { background: #f1f4f7; padding: 20px; border-bottom: 1px solid #dee2e6; }
        .section-title { font-weight: 700; color: #1a2a3a; border-left: 4px solid #0d6efd; padding-left: 10px; margin-bottom: 16px; }
        .subject-table th { background: #f8f9fa; text-transform: uppercase; font-size: 0.78rem; letter-spacing: 1px; }
        .att-table th { background: #1a2a3a; color: white; text-align: center; }
        .att-table td { text-align: center; vertical-align: middle; }
        .att-table .subject-name { text-align: left; font-weight: 600; }
        .type-th { background:#0d6efd; color:white; padding:2px 8px; border-radius:12px; font-size:0.78rem; font-weight:700; }
        .type-pr { background:#198754; color:white; padding:2px 8px; border-radius:12px; font-size:0.78rem; font-weight:700; }
        .pct-low  { color:#dc3545; font-weight:700; }
        .pct-ok   { color:#fd7e14; font-weight:700; }
        .pct-good { color:#198754; font-weight:700; }
        .grade-badge { font-size: 2rem; font-weight: 800; color: #e67e22; }
        .chart-card { background:#f8f9fa; border-radius:10px; padding:16px; }
        .footer-note { font-size: 0.8rem; color: #95a5a6; border-top: 1px solid #eee; padding-top: 15px; margin-top: 30px; }
        @media print {
            .no-print { display: none; }
            .report-card { box-shadow: none; }
            body { background: white; }
        }
    </style>
</head>
<body>
<div class="container report-container">

    <div class="d-flex justify-content-between mb-3 no-print">
        <a href="/" class="btn btn-outline-secondary btn-sm">← Back to Dashboard</a>
        <button onclick="window.print()" class="btn btn-primary btn-sm">🖨 Print / Download PDF</button>
    </div>

    <div class="report-card">
        <%-- HEADER --%>
        <div class="header-banner">
            <h1 class="display-6 fw-bold m-0">ENGINEERING DEPARTMENT</h1>
            <p class="lead m-0 opacity-75">Official Academic Transcript</p>
        </div>

        <%-- STUDENT META --%>
        <div class="student-meta">
            <div class="row">
                <div class="col-md-6">
                    <small class="text-muted text-uppercase">Student Name</small>
                    <h4 class="fw-bold">${s.name}</h4>
                    <small class="text-muted text-uppercase">Course / Branch</small>
                    <p class="fw-semibold">${s.course}</p>
                </div>
                <div class="col-md-6 text-md-end">
                    <small class="text-muted text-uppercase">Roll Number / ID</small>
                    <p class="fw-bold">#SMS-${s.id}00</p>
                    <small class="text-muted text-uppercase">Username</small>
                    <p><code>${s.username}</code></p>
                </div>
            </div>
        </div>

        <div class="p-4">

            <%-- MARKS TABLE --%>
            <h5 class="section-title">1. Subject-wise Assessment</h5>
            <table class="table table-bordered subject-table mb-4">
                <thead>
                    <tr>
                        <th>Subject</th><th class="text-center">Max Marks</th>
                        <th class="text-center">Obtained</th><th class="text-center">Status</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Mathematics</td><td class="text-center">100</td>
                        <td class="text-center fw-bold"><c:out value="${s.math != null ? s.math : '--'}"/></td>
                        <td class="text-center">
                            <c:choose>
                                <c:when test="${s.math != null and s.math >= 40}"><span class="text-success fw-bold">Pass</span></c:when>
                                <c:when test="${s.math != null}"><span class="text-danger fw-bold">Fail</span></c:when>
                                <c:otherwise><span class="text-muted">--</span></c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    <tr>
                        <td>Applied Physics</td><td class="text-center">100</td>
                        <td class="text-center fw-bold"><c:out value="${s.physics != null ? s.physics : '--'}"/></td>
                        <td class="text-center">
                            <c:choose>
                                <c:when test="${s.physics != null and s.physics >= 40}"><span class="text-success fw-bold">Pass</span></c:when>
                                <c:when test="${s.physics != null}"><span class="text-danger fw-bold">Fail</span></c:when>
                                <c:otherwise><span class="text-muted">--</span></c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    <tr>
                        <td>Programming in C</td><td class="text-center">100</td>
                        <td class="text-center fw-bold"><c:out value="${s.programming != null ? s.programming : '--'}"/></td>
                        <td class="text-center">
                            <c:choose>
                                <c:when test="${s.programming != null and s.programming >= 40}"><span class="text-success fw-bold">Pass</span></c:when>
                                <c:when test="${s.programming != null}"><span class="text-danger fw-bold">Fail</span></c:when>
                                <c:otherwise><span class="text-muted">--</span></c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    <tr>
                        <td>Basic Electronics</td><td class="text-center">100</td>
                        <td class="text-center fw-bold"><c:out value="${s.electronics != null ? s.electronics : '--'}"/></td>
                        <td class="text-center">
                            <c:choose>
                                <c:when test="${s.electronics != null and s.electronics >= 40}"><span class="text-success fw-bold">Pass</span></c:when>
                                <c:when test="${s.electronics != null}"><span class="text-danger fw-bold">Fail</span></c:when>
                                <c:otherwise><span class="text-muted">--</span></c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    <tr>
                        <td>Engineering Mechanics</td><td class="text-center">100</td>
                        <td class="text-center fw-bold"><c:out value="${s.mechanics != null ? s.mechanics : '--'}"/></td>
                        <td class="text-center">
                            <c:choose>
                                <c:when test="${s.mechanics != null and s.mechanics >= 40}"><span class="text-success fw-bold">Pass</span></c:when>
                                <c:when test="${s.mechanics != null}"><span class="text-danger fw-bold">Fail</span></c:when>
                                <c:otherwise><span class="text-muted">--</span></c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </tbody>
                <tfoot class="table-secondary fw-bold">
                    <tr>
                        <td>AGGREGATE TOTAL</td><td class="text-center">500</td>
                        <td class="text-center text-primary fs-5">${s.totalMarks != null ? s.totalMarks : '0.0'}</td>
                        <td class="text-center">
                            <c:choose>
                                <c:when test="${s.grade == 'F'}"><span class="text-danger fw-bold">RE-APPEAR</span></c:when>
                                <c:when test="${s.grade != null}"><span class="text-success fw-bold">PROMOTED</span></c:when>
                                <c:otherwise>--</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </tfoot>
            </table>

            <%-- GRADE ROW --%>
            <div class="row text-center g-3 mb-5">
                <div class="col-md-4">
                    <div class="p-3 border rounded">
                        <small class="text-muted d-block text-uppercase">Final Grade</small>
                        <span class="grade-badge">${s.grade != null ? s.grade : 'N/A'}</span>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="p-3 border rounded">
                        <small class="text-muted d-block text-uppercase">Overall Attendance</small>
                        <span class="fs-3 fw-bold ${allPct < 75 ? 'text-danger' : 'text-success'}">${allPct}%</span>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="p-3 border rounded">
                        <small class="text-muted d-block text-uppercase">Result</small>
                        <c:choose>
                            <c:when test="${s.grade == 'F'}"><span class="fs-5 fw-bold text-danger">RE-APPEAR</span></c:when>
                            <c:when test="${s.grade != null}"><span class="fs-5 fw-bold text-success">PROMOTED</span></c:when>
                            <c:otherwise><span class="text-muted">Pending</span></c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <%-- ATTENDANCE TABLE --%>
            <h5 class="section-title">2. Subject-wise Attendance</h5>
            <table class="table table-bordered att-table mb-4">
                <thead>
                    <tr>
                        <th style="width:5%">Sr.</th>
                        <th style="width:30%;text-align:left;padding-left:12px">Subject</th>
                        <th>Type</th><th>Present</th><th>Total</th><th>Percentage</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="row" items="${attRows}" varStatus="loop">
                        <tr>
                            <td rowspan="2" class="fw-bold">${loop.index + 1}</td>
                            <td rowspan="2" class="subject-name ps-3">${row.subject}</td>
                            <td><span class="type-th">TH</span></td>
                            <c:choose>
                                <c:when test="${row.th != null}">
                                    <td>${row.th.presentPeriods}</td><td>${row.th.totalPeriods}</td>
                                    <td class="${row.th.percentage < 75 ? 'pct-low' : row.th.percentage < 85 ? 'pct-ok' : 'pct-good'}">${row.th.percentage}%</td>
                                </c:when>
                                <c:otherwise><td class="text-muted">--</td><td class="text-muted">--</td><td class="text-muted">--</td></c:otherwise>
                            </c:choose>
                        </tr>
                        <tr>
                            <td><span class="type-pr">PR</span></td>
                            <c:choose>
                                <c:when test="${row.pr != null}">
                                    <td>${row.pr.presentPeriods}</td><td>${row.pr.totalPeriods}</td>
                                    <td class="${row.pr.percentage < 75 ? 'pct-low' : row.pr.percentage < 85 ? 'pct-ok' : 'pct-good'}">${row.pr.percentage}%</td>
                                </c:when>
                                <c:otherwise><td class="text-muted">--</td><td class="text-muted">--</td><td class="text-muted">--</td></c:otherwise>
                            </c:choose>
                        </tr>
                    </c:forEach>
                </tbody>
                <tfoot>
                    <tr class="table-secondary fw-bold">
                        <td colspan="3" class="text-end pe-3">Theory Total</td>
                        <td>${thPresent}</td><td>${thTotal}</td>
                        <td class="${thPct < 75 ? 'pct-low' : thPct < 85 ? 'pct-ok' : 'pct-good'}">${thPct}%</td>
                    </tr>
                    <tr class="table-success fw-bold">
                        <td colspan="3" class="text-end pe-3">Practical Total</td>
                        <td>${prPresent}</td><td>${prTotal}</td>
                        <td class="${prPct < 75 ? 'pct-low' : prPct < 85 ? 'pct-ok' : 'pct-good'}">${prPct}%</td>
                    </tr>
                    <tr class="table-info fw-bold">
                        <td colspan="3" class="text-end pe-3">Overall Total</td>
                        <td>${allPresent}</td><td>${allTotal}</td>
                        <td class="${allPct < 75 ? 'pct-low' : allPct < 85 ? 'pct-ok' : 'pct-good'}">${allPct}%</td>
                    </tr>
                </tfoot>
            </table>

            <%-- CHARTS --%>
            <h5 class="section-title">3. Attendance Charts</h5>
            <div class="row g-4 mb-4">
                <div class="col-md-6">
                    <div class="chart-card">
                        <h6 class="text-center fw-bold mb-3">Subject Theory Attendance (%)</h6>
                        <canvas id="thChart" height="200"></canvas>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="chart-card">
                        <h6 class="text-center fw-bold mb-3">Practical Attendance (%)</h6>
                        <canvas id="prChart" height="200"></canvas>
                    </div>
                </div>
            </div>

            <%-- SIGNATURES --%>
            <div class="row mt-5 pt-4">
                <div class="col-6 text-center">
                    <div style="width:160px;border-bottom:1px solid #000;margin:0 auto 8px;"></div>
                    <p class="small fw-bold mb-0">Department Coordinator</p>
                </div>
                <div class="col-6 text-center">
                    <div style="width:160px;border-bottom:1px solid #000;margin:0 auto 8px;"></div>
                    <p class="small fw-bold mb-0">Registrar (Examination)</p>
                </div>
            </div>

            <div class="footer-note text-center">
                <p class="mb-0">This document is an electronic record generated by the Student Management System.</p>
            </div>
        </div>
    </div>
</div>

<script>
    const labels = [${chartLabels}];
    const thData = [${chartThPct}];
    const prData = [${chartPrPct}];

    function barColor(val) {
        if (val < 75) return '#dc3545';
        if (val < 85) return '#fd7e14';
        return '#198754';
    }

    function makeChart(id, data, title) {
        new Chart(document.getElementById(id), {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{ label: title, data: data, backgroundColor: data.map(barColor), borderRadius: 6 }]
            },
            options: {
                responsive: true,
                plugins: { legend: { display: false } },
                scales: {
                    y: { min: 0, max: 100, ticks: { callback: v => v + '%' }, grid: { color: '#e9ecef' } },
                    x: { grid: { display: false } }
                }
            },
            plugins: [{
                afterDatasetsDraw(chart) {
                    const ctx = chart.ctx;
                    chart.data.datasets.forEach((ds, i) => {
                        chart.getDatasetMeta(i).data.forEach((bar, idx) => {
                            ctx.fillStyle = '#333';
                            ctx.font = 'bold 12px sans-serif';
                            ctx.textAlign = 'center';
                            ctx.fillText(ds.data[idx] + '%', bar.x, bar.y - 6);
                        });
                    });
                }
            }]
        });
    }

    makeChart('thChart', thData, 'Theory %');
    makeChart('prChart', prData, 'Practical %');
</script>
</body>
</html>
