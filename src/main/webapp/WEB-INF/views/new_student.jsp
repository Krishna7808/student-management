<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SMS Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body { background: #f0f2f5; }
        .navbar-custom { background: #1a2a3a; }

        /* Student Card */
        .student-card {
            background: white;
            border-radius: 14px;
            border: 1px solid #e0e6ed;
            overflow: hidden;
            transition: box-shadow 0.2s;
        }
        .student-card:hover { box-shadow: 0 6px 20px rgba(0,0,0,0.10); }
        .card-header-bar {
            background: linear-gradient(135deg, #1a2a3a, #2c4a6a);
            color: white;
            padding: 18px 20px 14px;
        }
        .avatar-circle {
            width: 48px; height: 48px;
            background: rgba(255,255,255,0.2);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.3rem; font-weight: 700; color: white;
            flex-shrink: 0;
        }

        /* Tab icons */
        .tab-icons { border-top: 1px solid #e9ecef; display: flex; }
        .tab-btn {
            flex: 1; border: none; background: none;
            padding: 10px 6px; font-size: 0.72rem; font-weight: 600;
            color: #6c757d; cursor: pointer;
            display: flex; flex-direction: column; align-items: center; gap: 4px;
            transition: all 0.15s; border-top: 3px solid transparent;
        }
        .tab-btn i { font-size: 1.1rem; }
        .tab-btn:hover { color: #0d6efd; background: #f8f9ff; }
        .tab-btn.active { color: #0d6efd; border-top-color: #0d6efd; background: #f0f4ff; }
        .tab-btn.active-green { color: #198754; border-top-color: #198754; background: #f0fff5; }
        .tab-btn.active-orange { color: #fd7e14; border-top-color: #fd7e14; background: #fff8f0; }

        /* Tab content panel */
        .tab-panel { display: none; padding: 16px 18px; }
        .tab-panel.active { display: block; }

        /* Info tab */
        .info-row { display: flex; align-items: center; gap: 10px; padding: 6px 0; font-size: 0.85rem; }
        .info-label { color: #6c757d; width: 90px; flex-shrink: 0; font-size: 0.75rem; text-transform: uppercase; font-weight: 600; }
        .info-value { color: #1a2a3a; font-weight: 500; }

        /* Marks tab */
        .marks-mini-table { font-size: 0.82rem; }
        .marks-mini-table th { background: #1a2a3a; color: white; font-size: 0.75rem; padding: 6px 8px; }
        .marks-mini-table td { padding: 5px 8px; vertical-align: middle; }
        .grade-pill { font-size: 1.5rem; font-weight: 800; color: #e67e22; }

        /* Attendance tab */
        .att-mini-table { font-size: 0.82rem; }
        .att-mini-table th { background: #1a2a3a; color: white; font-size: 0.75rem; padding: 6px 8px; text-align: center; }
        .att-mini-table td { padding: 5px 8px; text-align: center; vertical-align: middle; }
        .type-th { background:#0d6efd; color:white; padding:1px 7px; border-radius:10px; font-size:0.72rem; font-weight:700; }
        .type-pr { background:#198754; color:white; padding:1px 7px; border-radius:10px; font-size:0.72rem; font-weight:700; }
        .pct-low  { color:#dc3545; font-weight:700; }
        .pct-ok   { color:#fd7e14; font-weight:700; }
        .pct-good { color:#198754; font-weight:700; }
        .chart-wrap { margin-top: 14px; }

        /* Faculty action buttons */
        .fac-actions { border-top: 1px solid #f0f0f0; padding: 10px 18px; display: flex; gap: 6px; background: #fafafa; }
        .fac-actions .btn { font-size: 0.75rem; padding: 4px 10px; }

        /* Modal */
        .modal-header-primary { background: #0d6efd; color: white; }
        .modal-header-info    { background: #0dcaf0; color: white; }
    </style>
</head>
<body>

<nav class="navbar navbar-custom navbar-dark shadow-sm mb-4">
    <div class="container">
        <a class="navbar-brand fw-bold" href="/">🎓 ENG-STUDENT PORTAL</a>
        <div class="navbar-text text-white d-flex align-items-center gap-3">
            <span><span class="badge bg-primary me-1">${sessionScope.userRole}</span><strong>${sessionScope.userName}</strong></span>
            <a href="/logout" class="btn btn-outline-light btn-sm">Logout</a>
        </div>
    </div>
</nav>

<div class="container pb-5">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="fw-bold mb-0">Engineering Department Records</h4>
        <c:if test="${sessionScope.userRole == 'FACULTY'}">
            <a href="/showNewStudentForm" class="btn btn-primary shadow-sm">
                <i class="fas fa-user-plus me-1"></i> Register Student
            </a>
        </c:if>
    </div>

    <%-- ===== STUDENT CARDS GRID ===== --%>
    <div class="row g-4">
        <c:forEach var="s" items="${listStudents}" varStatus="vs">
            <div class="col-xl-4 col-lg-6">
                <div class="student-card shadow-sm">

                    <%-- Card Header --%>
                    <div class="card-header-bar d-flex align-items-center gap-3">
                        <div class="avatar-circle">${s.name.substring(0,1)}</div>
                        <div class="flex-grow-1 overflow-hidden">
                            <div class="fw-bold fs-6 text-truncate">${s.name}</div>
                            <small class="opacity-75">${s.course}</small>
                        </div>
                        <span class="badge ${s.grade == 'F' ? 'bg-danger' : s.grade != null ? 'bg-success' : 'bg-secondary'} fs-6 px-3">
                            ${s.grade != null ? s.grade : 'N/A'}
                        </span>
                    </div>

                    <%-- Tab Icon Buttons --%>
                    <div class="tab-icons">
                        <button class="tab-btn active" onclick="switchTab(this, 'info-${vs.index}', 'active')">
                            <i class="fas fa-id-card"></i> Info
                        </button>
                        <button class="tab-btn" onclick="switchTab(this, 'marks-${vs.index}', 'active-green')">
                            <i class="fas fa-graduation-cap"></i> Academic
                        </button>
                        <button class="tab-btn" onclick="switchTab(this, 'att-${vs.index}', 'active-orange')">
                            <i class="fas fa-calendar-check"></i> Attendance
                        </button>
                    </div>

                    <%-- INFO TAB --%>
                    <div id="info-${vs.index}" class="tab-panel active">
                        <div class="info-row"><span class="info-label">Name</span><span class="info-value">${s.name}</span></div>
                        <div class="info-row"><span class="info-label">Email</span><span class="info-value text-truncate">${s.email}</span></div>
                        <div class="info-row"><span class="info-label">Username</span><span class="info-value"><code>${s.username}</code></span></div>
                        <div class="info-row"><span class="info-label">Course</span><span class="info-value">${s.course}</span></div>
                        <div class="info-row"><span class="info-label">Student ID</span><span class="info-value">#SMS-${s.id}00</span></div>
                    </div>

                    <%-- ACADEMIC REPORT TAB --%>
                    <div id="marks-${vs.index}" class="tab-panel">
                        <table class="table table-sm table-bordered marks-mini-table mb-2">
                            <thead>
                                <tr><th>Subject</th><th class="text-center">Marks</th><th class="text-center">Status</th></tr>
                            </thead>
                            <tbody>
                                <tr><td>Mathematics</td>
                                    <td class="text-center">${s.math != null ? s.math : '--'}</td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${s.math != null and s.math >= 40}"><span class="text-success fw-bold">✓</span></c:when>
                                            <c:when test="${s.math != null}"><span class="text-danger fw-bold">✗</span></c:when>
                                            <c:otherwise>--</c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                                <tr><td>Physics</td>
                                    <td class="text-center">${s.physics != null ? s.physics : '--'}</td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${s.physics != null and s.physics >= 40}"><span class="text-success fw-bold">✓</span></c:when>
                                            <c:when test="${s.physics != null}"><span class="text-danger fw-bold">✗</span></c:when>
                                            <c:otherwise>--</c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                                <tr><td>Programming</td>
                                    <td class="text-center">${s.programming != null ? s.programming : '--'}</td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${s.programming != null and s.programming >= 40}"><span class="text-success fw-bold">✓</span></c:when>
                                            <c:when test="${s.programming != null}"><span class="text-danger fw-bold">✗</span></c:when>
                                            <c:otherwise>--</c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                                <tr><td>Electronics</td>
                                    <td class="text-center">${s.electronics != null ? s.electronics : '--'}</td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${s.electronics != null and s.electronics >= 40}"><span class="text-success fw-bold">✓</span></c:when>
                                            <c:when test="${s.electronics != null}"><span class="text-danger fw-bold">✗</span></c:when>
                                            <c:otherwise>--</c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                                <tr><td>Mechanics</td>
                                    <td class="text-center">${s.mechanics != null ? s.mechanics : '--'}</td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${s.mechanics != null and s.mechanics >= 40}"><span class="text-success fw-bold">✓</span></c:when>
                                            <c:when test="${s.mechanics != null}"><span class="text-danger fw-bold">✗</span></c:when>
                                            <c:otherwise>--</c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </tbody>
                            <tfoot>
                                <tr class="table-light fw-bold">
                                    <td>Total</td>
                                    <td class="text-center text-primary">${s.totalMarks != null ? s.totalMarks : '--'} / 500</td>
                                    <td class="text-center">
                                        <span class="badge ${s.grade == 'F' ? 'bg-danger' : 'bg-dark'}">${s.grade != null ? s.grade : 'N/A'}</span>
                                    </td>
                                </tr>
                            </tfoot>
                        </table>

                        <%-- Mini bar chart for marks --%>
                        <div class="chart-wrap">
                            <canvas id="marksChart-${vs.index}" height="130"></canvas>
                        </div>
                        <script>
                        (function() {
                            const subjects = ['Math','Physics','Prog','Elec','Mech'];
                            const scores   = [
                                ${s.math != null ? s.math : 0},
                                ${s.physics != null ? s.physics : 0},
                                ${s.programming != null ? s.programming : 0},
                                ${s.electronics != null ? s.electronics : 0},
                                ${s.mechanics != null ? s.mechanics : 0}
                            ];
                            const colors = scores.map(v => v >= 75 ? '#198754' : v >= 40 ? '#fd7e14' : '#dc3545');
                            new Chart(document.getElementById('marksChart-${vs.index}'), {
                                type: 'bar',
                                data: { labels: subjects, datasets: [{ data: scores, backgroundColor: colors, borderRadius: 5 }] },
                                options: {
                                    responsive: true,
                                    plugins: { legend: { display: false } },
                                    scales: {
                                        y: { min: 0, max: 100, ticks: { font: { size: 10 } } },
                                        x: { ticks: { font: { size: 10 } }, grid: { display: false } }
                                    }
                                },
                                plugins: [{
                                    afterDatasetsDraw(chart) {
                                        const ctx = chart.ctx;
                                        chart.data.datasets.forEach((ds, i) => {
                                            chart.getDatasetMeta(i).data.forEach((bar, idx) => {
                                                if (ds.data[idx] > 0) {
                                                    ctx.fillStyle = '#333'; ctx.font = 'bold 10px sans-serif'; ctx.textAlign = 'center';
                                                    ctx.fillText(ds.data[idx], bar.x, bar.y - 4);
                                                }
                                            });
                                        });
                                    }
                                }]
                            });
                        })();
                        </script>
                    </div>

                    <%-- ATTENDANCE TAB --%>
                    <div id="att-${vs.index}" class="tab-panel">
                        <c:set var="attRows"    value="${attDataMap[s.id]}" />
                        <c:set var="attLabels"  value="${chartLabelsMap[s.id]}" />
                        <c:set var="attThPct"   value="${chartThMap[s.id]}" />
                        <c:set var="attPrPct"   value="${chartPrMap[s.id]}" />
                        <c:choose>
                            <c:when test="${not empty attRows}">
                                <table class="table table-sm table-bordered att-mini-table mb-2">
                                    <thead>
                                        <tr><th class="text-start">Subject</th><th>Type</th><th>Present</th><th>Total</th><th>%</th></tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="row" items="${attRows}">
                                            <tr>
                                                <td class="text-start" rowspan="2">${row.subject}</td>
                                                <td><span class="type-th">TH</span></td>
                                                <c:choose>
                                                    <c:when test="${row.th != null}">
                                                        <td>${row.th.presentPeriods}</td><td>${row.th.totalPeriods}</td>
                                                        <td class="${row.th.percentage < 75 ? 'pct-low' : row.th.percentage < 85 ? 'pct-ok' : 'pct-good'}">${row.th.percentage}%</td>
                                                    </c:when>
                                                    <c:otherwise><td>--</td><td>--</td><td class="text-muted">--</td></c:otherwise>
                                                </c:choose>
                                            </tr>
                                            <tr>
                                                <td><span class="type-pr">PR</span></td>
                                                <c:choose>
                                                    <c:when test="${row.pr != null}">
                                                        <td>${row.pr.presentPeriods}</td><td>${row.pr.totalPeriods}</td>
                                                        <td class="${row.pr.percentage < 75 ? 'pct-low' : row.pr.percentage < 85 ? 'pct-ok' : 'pct-good'}">${row.pr.percentage}%</td>
                                                    </c:when>
                                                    <c:otherwise><td>--</td><td>--</td><td class="text-muted">--</td></c:otherwise>
                                                </c:choose>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                                <div class="chart-wrap">
                                    <canvas id="attChart-${vs.index}" height="130"></canvas>
                                </div>
                                <script>
                                (function() {
                                    const labels = [${attLabels}];
                                    const thData = [${attThPct}];
                                    const prData = [${attPrPct}];
                                    new Chart(document.getElementById('attChart-${vs.index}'), {
                                        type: 'bar',
                                        data: {
                                            labels: labels,
                                            datasets: [
                                                { label: 'TH %', data: thData, backgroundColor: '#0d6efd', borderRadius: 4 },
                                                { label: 'PR %', data: prData, backgroundColor: '#198754', borderRadius: 4 }
                                            ]
                                        },
                                        options: {
                                            responsive: true,
                                            plugins: { legend: { position: 'bottom', labels: { font: { size: 10 } } } },
                                            scales: {
                                                y: { min: 0, max: 100, ticks: { callback: v => v + '%', font: { size: 10 } } },
                                                x: { ticks: { font: { size: 10 } }, grid: { display: false } }
                                            }
                                        }
                                    });
                                })();
                                </script>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center text-muted py-4">
                                    <i class="fas fa-calendar-times fa-2x mb-2 d-block"></i>
                                    No attendance recorded yet.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <%-- Faculty Action Buttons --%>
                    <c:if test="${sessionScope.userRole == 'FACULTY'}">
                        <div class="fac-actions">
                            <a href="/showAddMarksForm/${s.id}" class="btn btn-outline-success btn-sm">
                                <i class="fas fa-pen me-1"></i>Marks
                            </a>
                            <a href="/markAttendance/${s.id}" class="btn btn-outline-warning btn-sm">
                                <i class="fas fa-calendar-check me-1"></i>Attendance
                            </a>
                            <a href="/showFormForUpdate/${s.id}" class="btn btn-outline-secondary btn-sm">
                                <i class="fas fa-edit me-1"></i>Edit
                            </a>
                            <a href="/deleteStudent/${s.id}" class="btn btn-outline-danger btn-sm ms-auto"
                               onclick="return confirm('Delete this student permanently?')">
                                <i class="fas fa-trash"></i>
                            </a>
                        </div>
                    </c:if>
                </div>
            </div>
        </c:forEach>

        <c:if test="${empty listStudents}">
            <div class="col-12 text-center py-5 text-muted">
                <i class="fas fa-users fa-3x mb-3 d-block"></i>
                No students registered yet.
                <c:if test="${sessionScope.userRole == 'FACULTY'}">
                    <br><a href="/showNewStudentForm" class="btn btn-primary mt-3">Register First Student</a>
                </c:if>
            </div>
        </c:if>
    </div>

    <%-- ===== ADD / EDIT STUDENT MODAL (Faculty Only) ===== --%>
    <c:if test="${showForm}">
    <div class="modal fade show d-block" style="background:rgba(0,0,0,0.6);">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg">
                <div class="modal-header ${formType == 'MARKS' ? 'modal-header-info' : 'modal-header-primary'}">
                    <h5 class="modal-title fw-bold">
                        <i class="fas ${formType == 'MARKS' ? 'fa-graduation-cap' : 'fa-user-plus'} me-2"></i>
                        ${formType == 'MARKS' ? 'Enter Subject Marks' : 'Register New Student'}
                    </h5>
                    <a href="/" class="btn-close btn-close-white"></a>
                </div>
                <div class="modal-body p-4">
                    <form:form action="/saveStudent" modelAttribute="student" method="POST">
                        <form:hidden path="id"/>
                        <c:choose>
                            <c:when test="${formType == 'MARKS'}">
                                <form:hidden path="name"/>
                                <form:hidden path="email"/>
                                <form:hidden path="username"/>
                                <form:hidden path="course"/>
                                <p class="text-muted mb-4">Entering marks for <strong>${student.name}</strong></p>
                                <div class="row g-3">
                                    <div class="col-md-4">
                                        <label class="form-label fw-bold">Mathematics <span class="text-danger small">(Max 100)</span></label>
                                        <form:input path="math" type="number" max="100" min="0" class="form-control" required="true"/>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label fw-bold">Physics <span class="text-danger small">(Max 100)</span></label>
                                        <form:input path="physics" type="number" max="100" min="0" class="form-control" required="true"/>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label fw-bold">Programming <span class="text-danger small">(Max 100)</span></label>
                                        <form:input path="programming" type="number" max="100" min="0" class="form-control" required="true"/>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label fw-bold">Electronics <span class="text-danger small">(Max 100)</span></label>
                                        <form:input path="electronics" type="number" max="100" min="0" class="form-control" required="true"/>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label fw-bold">Mechanics <span class="text-danger small">(Max 100)</span></label>
                                        <form:input path="mechanics" type="number" max="100" min="0" class="form-control" required="true"/>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold">Full Name</label>
                                        <form:input path="name" class="form-control" required="true"/>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold">Email</label>
                                        <form:input path="email" type="email" class="form-control" required="true"/>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold">Portal Username</label>
                                        <form:input path="username" class="form-control" required="true"/>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold">Course</label>
                                        <form:input path="course" class="form-control" required="true"/>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                        <div class="mt-4 pt-3 border-top d-flex justify-content-end gap-2">
                            <a href="/" class="btn btn-light">Cancel</a>
                            <button type="submit" class="btn btn-success px-5 fw-bold">Save</button>
                        </div>
                    </form:form>
                </div>
            </div>
        </div>
    </div>
    </c:if>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
function switchTab(clickedBtn, panelId, activeClass) {
    const card = clickedBtn.closest('.student-card');
    card.querySelectorAll('.tab-btn').forEach(b => b.className = 'tab-btn');
    card.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));
    clickedBtn.classList.add(activeClass);
    document.getElementById(panelId).classList.add('active');
}
</script>
</body>
</html>