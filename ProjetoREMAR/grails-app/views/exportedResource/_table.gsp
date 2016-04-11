<ul class="collapsible">
    <li class="c">
        <div class="collapsible-header">
            <div class="my-div centered"><b>Usuário</b></div>
            <div class="my-div centered"><b>Acertos</b></div>
            <div class="my-div centered"><b>Erros</b></div>
            <div class="my-div centered"><b>Aproveitamento</b></div>
        </div>
    </li>
    <g:each in="${users}" var="user">
        <li>
            <div class="collapsible-header">
                <div class="my-div">${user.value.name}</div>
                <div class="my-div centered">${user.value.hits}</div>
                <div class="my-div centered">${user.value.errors}</div>
                <div class="my-div centered"><g:formatNumber number="${100 * user.value.hits / (user.value.hits + user.value.errors)}" type="number" maxFractionDigits="2" />%</div>
            </div>
        </li>
    </g:each>
</ul>