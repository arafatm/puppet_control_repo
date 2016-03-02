<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<sql:setDataSource var="ds" dataSource="jdbc/TestDB" />
<sql:query sql="select * from EMPLOYEES" var="rs" dataSource="${ds}" />

<html>
<head><title>Test Database Connection Pooling</title></head>
<body>
  <h2>Results</h2>
  <table>
    <c:forEach var="row" items="${rs.rows}">
    <tr>
    <td>${row.EMPLOYEE_ID}</td>
    <td>${row.EMPLOYEE_NAME}</td>
    </tr>
    </c:forEach>
  </table>
</body>
</html>
