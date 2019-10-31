<%--
  Created by IntelliJ IDEA.
  User: marcus
  Date: 06/10/15
  Time: 09:27
--%>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <g:javascript src="scriptTheme.js"/>
</head>
<body>
<div class="page-header">
    <h1> Criar Questões</h1>
</div>
<g:if test="${flash.message}">
    <div class="message" role="status">${flash.message}</div>
</g:if>
<div class="main-content">
    <div class="widget">
        <h3 class="section-title first-title"><i class="icon-table"></i> Criar uma questão</h3>
        <div class="widget-content-white glossed">
            <div class="padded">
                <g:if test="${flash.message}">
                    <div class="message" role="status">${flash.message}</div>
                </g:if>
                <g:hasErrors bean="${questionInstance}">
                    <ul class="errors" role="alert">
                        <g:eachError bean="${questionInstance}" var="error">
                            <li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>
                        </g:eachError>
                    </ul>
                </g:hasErrors>

                    <fieldset class="form">
                        <!-- Renderiza o formulário para criação de novo item -->
                        <g:render template="form"/>
                    </fieldset>
                    <br />

            </div>
        </div>
    </div>
</div>

<!-- Javascript -->
<g:javascript src="editableTable.js"/>
<g:javascript src="scriptTable.js"/>
<g:javascript src="validate.js"/>
<g:javascript src="question.js"/>
<script type="text/javascript" src="https://code.jquery.com/jquery-2.1.1.min.js"></script>
<script type="text/javascript" src="/forca-acessivel/js/materialize.min.js"></script>
<script type="text/javascript">

    function changeEditQuestion(variable) {
        var editQuestion = document.getElementById("editQuestionLabel");
        editQuestion.value = variable;

        console.log(editQuestion.value);
        //console.log(variable);
    }
</script>
<g:javascript src="recording.js"/>
<g:javascript src="recorder.js"/>
</body>
</html>