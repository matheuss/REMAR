<%--
  Created by IntelliJ IDEA.
  User: deniscapp
  Date: 7/8/16
  Time: 9:04 AM
--%>

<%@ page import="br.ufscar.sead.loa.remar.User" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="materialize-layout">
</head>

<body>
<div class="row">
    <!-- VERIFICAR USERSTATSMAP OU ALL STATS #CORRIGIR -->
    <g:if test="${hasContent}">
        <div class="col l12">

            <!-- o cabeçalho da página poderia estar aqui!
                 colocar depois para facilitar manutenção -->

            <g:if test="${isMultiple}">
                <g:render template="stats/multiple" />
            </g:if>
            <g:else>
                <g:render template="stats/normal" />
            </g:else>
        </div>
    </g:if>
    <g:else>
        <div class="col l12">
            <h5>Nenhuma estatística foi encontrada ou este jogo não possui suporte.</h5>
        </div>
    </g:else>

</div>
<script>
    $('.close').click(function(){
        $('.card-panel').fadeOut(500, function(){
            $(this).hide();
        })
    });
</script>

</body>
</html>