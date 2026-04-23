<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Enter Student Marks</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="container mt-5">

    <div class="card shadow">
        <div class="card-header bg-info text-white">
            <h3 class="card-title mb-0">Module 2: Add Subject Marks</h3>
        </div>
        <div class="card-body">
            <form:form action="/saveMarks" modelAttribute="marks" method="POST">
                
                <form:hidden path="studentId" />

                <div class="mb-3">
                    <label class="form-label">Subject Name</label>
                    <form:input path="subject" class="form-control" placeholder="e.g. Mathematics" required="true" />
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Marks Obtained</label>
                        <form:input path="obtainedMarks" type="number" class="form-control" required="true" />
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Maximum Marks</label>
                        <form:input path="maxMarks" type="number" class="form-control" required="true" />
                    </div>
                </div>

                <div class="mt-4">
                    <button type="submit" class="btn btn-success px-4">Save Marks</button>
                    <a href="/" class="btn btn-secondary px-4">Back to Dashboard</a>
                </div>

            </form:form>
        </div>
    </div>

</body>
</html>