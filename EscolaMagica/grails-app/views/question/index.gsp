<%@ page import="br.ufscar.sead.loa.escolamagica.remar.Question" %>
<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main">
        %{--<g:javascript src="questions.js" />--}%
        <g:javascript src="../assets/js/jquery.min.js"/>
        <g:javascript src="../assets/js/bootstrap.min.js"/>
        <link rel="stylesheet" href="${resource(dir: 'css', file: 'stylesheet.css')}" />
        <link rel="stylesheet" href="${resource(dir: 'assets/css', file: 'bootstrap.min.css')}" />
        <link rel="stylesheet" href="${resource(dir: 'assets/css', file: 'modal.css')}" />
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">
    </head>
    <body>
        <div class="page-header">
            <h1> Minhas Questões</h1>
        </div>
        <div class="main-content">
            <div class="widget">
                <div class="widget-content-white glossed">
                    <div class="padded">
                        <div class="table-responsive">
                            <g:if test="${flash.message}">
                                <div class="message" role="status">${flash.message}</div>
                                <br />
                            </g:if>
                            <div class="pull-left alert alert-info">
                                <i class="fa fa-info-circle"></i> Temos algumas questões-exemplo. Você pode editá-las!
                                Basta clicar sobre alguma <i class="fa fa-smile-o"></i><br>
                                <i class="fa fa-info-circle"></i> Não se esqueça: para finalizar a tarefa, são necessárias pelo menos 5 questões para cada nível!</i><br>
                            </div>
                            <div class="pull-right">
                                <g:if test="${Question.validateQuestions("${session.user.id}")}">
                                    <button class="btn btn-info btn-lg" id="submitButton" > Finalizar </button>
                                    %{--<g:link class="btn btn-info btn-lg" target="_parent" action="createXML" >Finalizar</g:link>--}%
                                </g:if>
                                <g:else>
                                    <button class="btn btn-warning btn-lg" id="noSubmitButton" data-toggle="tooltip" data-placement="right" title="Crie pelo menos 5 (cinco) questões de cada nível">Finalizar</button>
                                </g:else>


                                <button class="btn btn-success btn-lg" data-toggle="modal" href="create" data-target="#CreateModal">Nova Questão</button>
                                <br>
                                <br>

                                <div class="pull-right" style="margin-bottom: 15px;">
                                    <input  type="text" id="SearchLabel" placeholder="Buscar"/>
                                </div>
                            </div>
                            <table class="table table-striped table-bordered table-hover" id="table">
                                <thead>
                                    <tr>
                                        <th style="text-align: center">Selecionar </th>

                                        <g:sortableColumn property="level" title="${message(code: 'question.level.label', default: 'Nível')}" />

                                        <g:sortableColumn property="title" title="${message(code: 'question.title.label', default: 'Pergunta')}" />

                                        <g:sortableColumn property="answers" title="${message(code: 'question.answers.label', default: 'Respostas')}" />

                                        <g:sortableColumn property="correctAnswer" title="${message(code: 'question.correctAnswer.label', default: 'Alternativa Correta')}" />
                                    </tr>
                                    <tr style="height: 5px; width: 5px;">
                                        <th align="center"><input align="center" class="checkbox" type="checkbox" id="CheckAll" style="margin-left: 42%;"/></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <g:each in="${questionInstanceList}" status="i" var="questionInstance">
                                        <tr class="selectable_tr" style="cursor: pointer;"
                                            data-id="${fieldValue(bean: questionInstance, field: "id")}" data-owner-id="${fieldValue(bean: questionInstance, field: "ownerId")}" data-level="${fieldValue(bean: questionInstance, field: "level")}"
                                            data-checked="false"
                                        >

                                            <td class="_not_editable" align="center" > <input class="checkbox" type="checkbox"/> </td>

                                            <td class="level" data-toggle="modal" data-target="#EditModal" href="edit/${questionInstance.id}" >${fieldValue(bean: questionInstance, field: "level")}</td>

                                            <td data-toggle="modal" data-target="#EditModal" href="edit/${questionInstance.id}" >${fieldValue(bean: questionInstance, field: "title")}</td>

                                            <td data-toggle="modal" data-target="#EditModal" href="edit/${questionInstance.id}"  >${fieldValue(bean: questionInstance, field: "answers")}</td>

                                            <td data-toggle="modal" data-target="#EditModal" href="edit/${questionInstance.id}" >${questionInstance.answers[questionInstance.correctAnswer]} (${questionInstance.correctAnswer + 1}ª Alternativa)</td>
                                        </tr>
                                    </g:each>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    <!-- Create Question Modal -->
    <div class="modal fade" id="CreateModal" role="dialog">
        <div class="modal-dialog text-center">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                </div>
                <div class="modal-body">
                </div>
            </div>
        </div>
    </div>
    <!-- Edit Question Modal -->
    <div class="modal fade" id="EditModal" role="dialog">
        <div class="modal-dialog text-center ">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                </div>
                <div class="modal-body">
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        var x = document.getElementsByName("question_label");
        $(document).on("click", ".selectable_tr", function () {
            console.log("click event");
            var myNameId = $(this).data('id')
            var myCheck = $(this).data('checked')
            var myLevel = $(this).data('level')
            console.log(myNameId);
            console.log(myCheck);
            console.log(myLevel);
            $("#questionInstance").val( myNameId );

            $('body').on('hidden.bs.modal', '#EditModal', function (e) {
                console.log("entrou aqui");
                $(e.target).removeData("bs.modal");
                $("#EditModal > div > div > div").empty();
            });

        });

        $(function(){
            $("#SearchLabel").keyup(function(){
                _this = this;
                $.each($("#table tbody ").find("tr"), function() {
                    console.log($(this).text());
                    if($(this).text().toLowerCase().indexOf($(_this).val().toLowerCase()) == -1)
                        $(this).hide();
                    else
                        $(this).show();
                });
            });
        });

        $(document).ready(function () {

            $('.checkbox').on('change', function() {
                $(this).parent().parent().attr('data-checked', $(this).prop('checked'));
            });


            $("#CheckAll").click(function () {
                var CheckAll = document.getElementById("CheckAll");
                var trs = document.getElementById('table').getElementsByTagName("tbody")[0].getElementsByTagName('tr');
                $(".checkbox").prop('checked', $(this).prop('checked'));

                if(CheckAll.checked==true){
                    for (var i = 0; i < trs.length; i++) {
                        $(trs[i]).attr('data-checked', "true");
                    }
                }
                else{
                    for (var i = 0; i < trs.length; i++) {
                        $(trs[i]).attr('data-checked', "false");
                    }
                }


            });
        });

        $('#submitButton').click(function () {
            var list_id = [];
            var questions_level1 = 0;
            var questions_level2 = 0;
            var questions_level3 = 0;
            var trs = document.getElementById('table').getElementsByTagName("tbody")[0].getElementsByTagName('tr');
            for (var i = 0; i < trs.length; i++) {
                if ($(trs[i]).attr('data-checked') == "true") {
                    console.log($(trs[i]).attr('data-level'));

                    switch ($(trs[i]).attr('data-level')){
                        case "1":
                            questions_level1 += 1;
                            break;
                        case "2":
                            questions_level2 += 1;
                            break;
                        default :
                            questions_level3 += 1;
                    }

                    list_id.push(  $(trs[i]).attr('data-id') );
                }
            }
            console.log(list_id);
            console.log(questions_level1);
            console.log(questions_level2);
            console.log(questions_level3);

            if(questions_level1 >= 5 && questions_level2 >= 5 && questions_level3 >= 5){
                $.ajax({
                    type: "POST",
                    traditional: true,
                    url: "${createLink(controller: 'question', action: 'createXML')}",
                    data: { list_id: list_id },
                    success: function(returndata) {
                        window.top.location.href = returndata;
                    },
                    error: function(returndata) {
                        alert("Error:\n" + returndata.responseText);


                    }
                });
            }
            else
            {
                alert("Você deve selecionar no mínimo 5 (cinco) questões de cada nível.\nQuestões nível 1: " + questions_level1 +
                        "\nQuestões nível 2: " + questions_level2 + "\nQuestões nível 3: " + questions_level3);
            }

        });

        $('#noSubmitButton').click(function () {
            alert("Você deve criar no mínimo 5 (cinco) questões de cada nível.");
        })

    </script>

    </body>
</html>
