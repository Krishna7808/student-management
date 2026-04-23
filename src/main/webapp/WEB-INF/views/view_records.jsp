<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Academic Report</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body { background-color: #f0f2f5; }
        .section-title { font-weight: 700; color: #1a2a3a; border-left: 4px solid #0d6efd; padding-left: 10px; }
        .att-table th { background-color: #1a2a3a; color: white; text-align: center; }
        .att-table td { text-align: center; vertical-align: middle; }
        .att-table .subject-name { text-align: left; font-weight: 600; }
        .type-th { background:#0d6efd; color:white; padding:2px 8px; border-radius:12px; font-size:0.78rem; font-weight:700; }
        .type-pr { background:#198754; color:white; padding:2px 8px; border-radius:12px; font-size:0.78rem; font-weight:700; }
        .pct-low  { color:#dc3545; font-weight:700; }
        .pct-ok   { color:#fd7e14; font-weight:700; }
        .pct-good { color:#198754; font-weight:700; }
        .chart-card { background:white; border-radius:12px; padding:20px; box-shadow:0 2px 8px rgba(0,0,0,0.08); }
        @media print { .no-print { display:none; } }
    </style>
</head>
<body class="container-fluid px-4 py-4">

    <div class="d-flex justify-content-between align-items-center mb-4 no-print">
        <h4 class="fw-bold mb-0">📊 Academic Report</h4>
        <div>
            <a href="/" class="btn btn-dark btn-sm me-2">← Dashboard</a>
            <button class="btn btn-outline-primary btn-sm" onclick="window.print()">🖨 Print</button>
        </div>
    </div>

    <%-- ===== MARKS SECTION ===== --%>
    <div class="card shadow-sm border-0 rounded-3 mb-4">
        <div class="card-body p-4">
            <h5 class="section-title mb-4">1. Academic Performance</h5>
            <table class="table table-bordered text-center">
                <thead class="table-dark">
                    <tr><th>Subject</th><th>Obtained Marks</th><th>Maximum Marks</th></tr>
                </thead>
                <tbody>
                    <c:forEach var="mark" items="${marksList}">
                        <tr>
                            <td class="text-start ps-3">${mark.subject}</td>
                            <td>${mark.obtainedMarks}</td>
                            <td>${mark.maxMarks}</td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty marksList}">
                        <tr><td colspan="3" class="text-muted">No marks records available.</td></tr>
                    </c:if>
                </tbody>
                <tfoot>
                    <tr class="table-info fw-bold">
                        <td class="text-start ps-3">TOTAL</td>
                        <td>${totalObtained}</td>
                        <td>${totalMax}</td>
                    </tr>
                </tfoot>
            </table>
            <div class="alert alert-primary d-inline-block mt-1">
                <strong>Academic Percentage: ${academicPercent}%</strong>
            </div>
        </div>
    </div>

    <%-- ===== ATTENDANCE SECTION ===== --%>
    <div class="card shadow-sm border-0 rounded-3 mb-4">
        <div class="card-body p-4">
            <h5 class="section-title mb-4">2. Subject-wise Attendance</h5>
            <table class="table table-bordered att-table">
                <thead>
                    <tr>
                        <th style="width:5%">Sr.</th>
                        <th style="width:30%;text-align:left;padding-left:12px">Subject</th>
                        <th>Type</th>
                        <th>Present Periods</th>
                        <th>Total Periods</th>
                        <th>Percentage (%)</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="row" items="${attRows}" varStatus="loop">
                        <%-- Theory Row --%>
                        <tr>
                            <td rowspan="2" class="fw-bold">${loop.index + 1}</td>
                            <td rowspan="2" class="subject-name ps-3">${row.subject}</td>
                            <td><span class="type-th">TH</span></td>
                            <c:choose>
                                <c:when test="${row.th != null}">
                                    <td>${row.th.presentPeriods}</td>
                                    <td>${row.th.totalPeriods}</td>
                                    <td class="${row.th.percentage < 75 ? 'pct-low' : row.th.percentage < 85 ? 'pct-ok' : 'pct-good'}">
                                        ${row.th.percentage}%
                                    </td>
                                </c:when>
                                <c:otherwise>
                                    <td class="text-muted">--</td><td class="text-muted">--</td><td class="text-muted">--</td>
                                </c:otherwise>
                            </c:choose>
                        </tr>
                        <%-- Practical Row --%>
                        <tr>
                            <td><span class="type-pr">PR</span></td>
                            <c:choose>
                                <c:when test="${row.pr != null}">
                                    <td>${row.pr.presentPeriods}</td>
                                    <td>${row.pr.totalPeriods}</td>
                                    <td class="${row.pr.percentage < 75 ? 'pct-low' : row.pr.percentage < 85 ? 'pct-ok' : 'pct-good'}">
                                        ${row.pr.percentage}%
                                    </td>
                                </c:when>
                                <c:otherwise>
                                    <td class="text-muted">--</td><td class="text-muted">--</td><td class="text-muted">--</td>
                                </c:otherwise>
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
            <h5 class="section-title mt-5 mb-4">3. Attendance Charts</h5>
            <div class="row g-4">
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
        </div>
    </div>

<script>
    const labels  = [${chartLabels}];
    const thData  = [${chartThPct}];
    const prData  = [${chartPrPct}];

    function barColor(val) {
        if (val < 75)  return '#dc3545';
        if (val < 85)  return '#fd7e14';
        return '#198754';
    }

    function makeChart(id, data, title) {
        new Chart(document.getElementById(id), {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: title,
                    data: data,
                    backgroundColor: data.map(barColor),
                    borderRadius: 6,
                    borderSkipped: false
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { display: false },
                    datalabels: { display: false }
                },
                scales: {
                    y: {
                        min: 0, max: 100,
                        ticks: { callback: v => v + '%' },
                        grid: { color: '#e9ecef' }
                    },
                    x: { grid: { display: false } }
                }
            },
            plugins: [{
                afterDatasetsDraw(chart) {
                    const ctx = chart.ctx;
                    chart.data.datasets.forEach((dataset, i) => {
                        const meta = chart.getDatasetMeta(i);
                        meta.data.forEach((bar, index) => {
                            const val = dataset.data[index];
                            ctx.fillStyle = '#333';
                            ctx.font = 'bold 12px sans-serif';
                            ctx.textAlign = 'center';
                            ctx.fillText(val + '%', bar.x, bar.y - 6);
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
