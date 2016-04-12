<%@ page import="br.ufscar.sead.loa.quiforca.remar.Question" %>
<!DOCTYPE html>
<html>
<head>
    <!--Import Google Icon Font-->
    <link href="http://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <!--Import materialize.css-->
    <link type="text/css" rel="stylesheet" href="../css/materialize.css" media="screen,projection"/>
    <link rel="stylesheet" type="text/css" href="../css/style.css">

    <!--Let browser know website is optimized for mobile-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <meta name="layout" content="main">
    <meta charset="utf-8">
    <g:javascript src="editableTable.js"/>
    <g:javascript src="scriptTable.js"/>
    <g:javascript src="validate.js"/>
    <script type="text/javascript" src="https://code.jquery.com/jquery-2.1.1.min.js"></script>

    <meta property="user-name" content="${userName}"/>
    <meta property="user-id" content="${userId}"/>

    <g:set var="entityName" value="${message(code: 'question.label', default: 'Question')}"/>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">
    <g:javascript src="iframeResizer.contentWindow.min.js"/>

</head>

<body>
<div class="cluster-header">
    <p class="text-teal text-darken-3 left-align margin-bottom" style="font-size: 28px;">
        <i class="small material-icons left">grid_on</i>Tabela de Questões
    </p>
</div>


<div class="row">
    <div class="col s3 offset-s9">
        <input type="text" id="SearchLabel" placeholder="Buscar"/>
    </div>
</div>

<table class="highlight" id="table" style="margin-top: -30px;">
    <thead>
    <tr>
        <th>Selecionar %{--<div class="row">--}%
            <div class="row" style="margin-bottom: -10px;">
                %{--<input class="filled-in" type="checkbox" id="BtnCheckAll" onclick="check_all()"> <label for="BtnCheckAll"></label>--}%
                %{--<input class="filled-in" type="checkbox" id="BtnUnCheckAll" onclick="uncheck_all()"> <label for="BtnUnCheckAll"></label>--}%

                <button style="margin-left: 3px; background-color: #795548;" class="btn-floating" id="BtnCheckAll"
                        onclick="check_all()"><i class="material-icons">check_box_outline_blank</i></button>
                <button style="margin-left: 3px; background-color: #795548;" class="btn-floating" id="BtnUnCheckAll"
                        onclick="uncheck_all()"><i class="material-icons">done</i></button>
            </div>
        </th>
        <th>Pergunta <div class="row" style="margin-bottom: -10px;"><button class="btn-floating"
                                                                            style="visibility: hidden"></button></div>
        </th>
        <th>Resposta <div class="row" style="margin-bottom: -10px;"><button class="btn-floating"
                                                                            style="visibility: hidden"></button></div>
        </th>
        <th>Tema <div class="row" style="margin-bottom: -10px;"><button class="btn-floating"
                                                                        style="visibility: hidden"></button></div></th>
        <th>Autor <div class="row" style="margin-bottom: -10px;"><button class="btn-floating"
                                                                         style="visibility: hidden"></button></div></th>
        <th>Ação <div class="row" style="margin-bottom: -10px;"><button class="btn-floating"
                                                                        style="visibility: hidden"></button></div></th>
    </tr>
    </thead>

    <tbody>
    <g:each in="${questionInstanceList}" status="i" var="questionInstance">
        <tr class="selectable_tr ${(i % 2) == 0 ? 'even' : 'odd'} " style="cursor: pointer;"
            data-id="${fieldValue(bean: questionInstance, field: "id")}"
            data-owner-id="${fieldValue(bean: questionInstance, field: "ownerId")}"
            data-checked="false">
            <g:if test="${questionInstance.author == userName}">

                <td class="_not_editable"><input class="filled-in" type="checkbox"> <label></label></td>

                <td name="question_label">${fieldValue(bean: questionInstance, field: "statement")}</td>

                <td>${fieldValue(bean: questionInstance, field: "answer")}</td>

                <td name="theme" id="theme">${fieldValue(bean: questionInstance, field: "category")}</td>

                <td>${fieldValue(bean: questionInstance, field: "author")}</td>

                <td><i onclick="changeEditQuestion(${i})" style="color: #7d8fff; margin-right:10px;"
                       class="fa fa-pencil modal-trigger" data-target="editModal${i}"
                       data-model="${questionInstance.id}"></i> <i style="color: #7d8fff;" class="fa fa-trash-o"
                                                                   onclick="_delete($(this.closest('tr')))"></i></td>

                <!-- Modal Structure -->
                <div id="editModal${i}" class="modal">
                    <div class="modal-content">
                        <h4>Editar Questão</h4>

                        <div class="row">
                            <g:if test="${flash.message}">
                                <div class="message" role="status">${flash.message}</div>
                            </g:if>
                            <g:if test="${flash.message}">
                                <div class="message" role="status">${flash.message}</div>
                            </g:if>
                            <g:hasErrors bean="${questionInstance}">
                                <ul class="errors" role="alert">
                                    <g:eachError bean="${questionInstance}" var="error">
                                        <li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message
                                                error="${error}"/></li>
                                    </g:eachError>
                                </ul>
                            </g:hasErrors>
                            <g:form url="[resource: questionInstance, action: 'update']" method="PUT">
                                <g:hiddenField name="version" value="${questionInstance?.version}"/>
                                <g:render template="form" model="[questionInstance: questionInstance]"/>
                                <g:actionSubmit class="save btn btn-success btn-lg my-orange" action="update"
                                                value="${message(code: 'default.button.update.label', default: 'Salvar')}"/>
                            </g:form>
                        </div>
                    </div>
                </div>

            </g:if>
            <g:else>
                <td class="_not_editable"><input class="filled-in" type="checkbox"> <label></label></td>

                <td name="question_label"
                    data-questionId="${questionInstance.id}">${fieldValue(bean: questionInstance, field: "statement")}</td>

                <td>${fieldValue(bean: questionInstance, field: "answer")}</td>

                <td name="theme" id="theme">${fieldValue(bean: questionInstance, field: "category")}</td>

                <td>${fieldValue(bean: questionInstance, field: "author")}</td>

                <td><i style="color: gray; margin-right:10px;" class="fa fa-pencil"></i>  <i style="color: gray;"
                                                                                             class="fa fa-trash-o"></i>
                </td>

            </g:else>
        </tr>
    </g:each>
    </tbody>
</table>

<input type="hidden" id="editQuestionLabel" value=""> <label for="editQuestionLabel"></label>

<div class="row">
    <div class="col s2">
        <button class="btn waves-effect waves-light my-orange" type="submit" name="save" id="save">Enviar
            <i class="material-icons right">send</i>
        </button>
    </div>

    <div class="col s1 offset-s8">
        <a data-target="createModal" name="create"
           class="btn-floating btn-large waves-effect waves-light modal-trigger my-orange tooltipped" data-tooltip="Criar questão"><i
                class="material-icons">add</i></a>
    </div>

    <div class="col s1">
        <a data-target="uploadModal"  class="btn-floating btn-large waves-effect waves-light my-orange modal-trigger tooltipped" data-tooltip="Upload de arquivo .csv"><i
                class="material-icons">file_upload</i></a>
    </div>
</div>



<!-- Modal Structure -->
<div id="createModal" class="modal">
    <div class="modal-content">

                <h4>Criar Questão <i class="material-icons tooltipped" data-position="right" data-delay="30" data-tooltip="Respostas não devem possuir números nem caracteres especiais.">info</i></h4>


        <div class="row">
            <g:form url="[resource: questionInstance, action: 'newQuestion']">
                <g:render template="form"/>
                <br/>
                <g:submitButton name="create" class="btn btn-success btn-lg my-orange"
                                value="${message(code: 'default.button.create.label', default: 'Create')}"/>
            </g:form>
        </div>
    </div>
</div>


<!-- Modal Structure -->
<div id="infoModal" class="modal">
    <div class="modal-content">
        <div id="totalQuestion">

        </div>
    </div>

    <div class="modal-footer">
        <button class="btn waves-effect waves-light modal-close my-orange">Entendi</button>
    </div>
</div>

<div id="uploadModal" class="modal">
    <div class="modal-content">
        <h4>Enviar arquivo .csv</h4>
        <br>
        <div class="row">
            <g:uploadForm action="generateQuestions">

                <div class="file-field input-field">
                    <div class="btn my-orange">
                        <span>File</span>
                        <input type="file" accept="text/csv" id="csv" name="csv">
                    </div>

                    <div class="file-path-wrapper">
                        <input class="file-path validate" type="text">
                    </div>
                </div>
                <div class="row">
                    <div class="col s1 offset-s10">
                        <g:submitButton class="btn my-orange" name="csv" value="Enviar"/>
                    </div>
                </div>
            </g:uploadForm>
        </div>

        <blockquote>Formatação do arquivo .csv</blockquote>
        <div class="row">
            <div class="col s6">
                <ol>
                    <li>O separador do arquivo .csv deve ser <b> ',' (vírgula)</b>  </li>
                    <li>O arquivo deve ser composto apenas por <b>dados</b></li>
                    <li>O arquivo deve representar a estrutura da tabela ao lado</li>
                </ol>
                <ul>
                    <li><a href="../samples/exemploForca.csv" >Download do arquivo exemplo</a></li>
                </ul>
            </div>
            <div class="col s6">
                <table class="center">
                    <thead>
                    <tr>
                        <th>Pergunta</th>
                        <th>Resposta</th>
                        <th>Tema</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td>Pergunta 1</td>
                        <td>Resposta 1</td>
                        <td>Exemplo</td>
                    </tr>
                    <tr>
                        <td>Pergunta 2</td>
                        <td>Resposta 2</td>
                        <td>Exemplo</td>
                    </tr>
                    <tr>
                        <td>Pergunta 3</td>
                        <td>Resposta 3</td>
                        <td>Exemplo</td>
                    </tr>
                    </tbody>
                </table>

            </div>
        </div>
    </div>
</div>





<script type="text/javascript" src="../js/materialize.min.js"></script>
<script type="text/javascript">

    function changeEditQuestion(variable) {
        var editQuestion = document.getElementById("editQuestionLabel");
        editQuestion.value = variable;

        console.log(editQuestion.value);
        //console.log(variable);
    }

</script>

</body>
</html>
