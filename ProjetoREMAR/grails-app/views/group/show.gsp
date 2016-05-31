<%--
  Created by IntelliJ IDEA.
  User: deniscapp
  Date: 5/18/16
  Time: 5:24 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="materialize-layout">
</head>

<body>
<div class="cluster-header">
    <div class="row">
        <div class="text-teal text-darken-3 left-align margin-bottom col l6 s8 offset-s3">
          ${group.name}
        </div>
        <div class="">
        <g:form controller="group" action="addUser">
            <div class="input-field col l3">
                <input name="term" id="search-user" type="text" required>
                <label for="search-user"><i class="fa fa-search"></i></label>
                <input type="hidden" value="${group.id}" name="groupid">
                <input type="hidden" value="" id="user-id" name="userid">
            </div>
            <div class="col l3">
                <button style="font-size: 0.5em; top: 1.2em; position:relative;" class="btn waves-effect waves-light" type="submit" name="action">Adicionar
                    <i class="material-icons right">group_add</i>
                </button>
            </div>
        </g:form>
        </div>
    </div>

    <div class="divider"></div>

    <div class="center-align">
        <p align="center" style="font-size: 0.6em;">Dono(s):
                <g:if test="${group.owner.id == session.user.id}">
                    Você
                </g:if><br>
                <g:if test="${group.admins.size() > 0}">
                    Admin(s):
                    <g:each status="i" var="admin" in="${group.admins}">
                            ${admin.firstName +" "+ admin.lastName}
                        <g:if test="${!(i == group.admins.size()-1)}">
                            /
                        </g:if>
                    </g:each>
                </g:if>
                %{--${owner.firstName +' '+ owner.lastName}--}%
        </p>
    </div>
</div>


<div class="row">
        <div class="col l12">
                <h5 class="right-align">Membros</h5>
                <g:each var="groupUser" in="${group.userGroups.toList()}" status="i">
                    <div id="user-card${groupUser.id}" style="overflow: visible !important; position: relative; left:7em;" class="card white col l3 offset-l8 s6">
                        <div class="card-image">
                            <div class="col l4 s4 left-align">
                                <img src="/data/users/${groupUser.user.username}/profile-picture" class="circle responsive-img">
                            </div>
                        </div>
                        <div class="card-content">
                            <div>
                                <p class="left-align truncate" style="top: 0.4em; position: relative;">${groupUser.user.firstName + " " + groupUser.user.lastName}</p>
                            </div>
                            <div class="col l1 s1 offset-l6 offset-s10">
                                <a class="dropdown-button"  id="drop" href="#" data-activates="dropdown-user-${groupUser.id}" style="color: black"><span class="material-icons">more_vert</span></a>
                            </div>
                            <ul id="dropdown-user-${groupUser.id}" class="dropdown-content">
                                <input id="user-group-id" type="hidden" value="${groupUser.id}" name="usergroupid">

                                <li><a onclick="deleteGroupUser();">Excluir</a></li>

                                <g:if test="${!group.admins.toList().contains(groupUser.user)}">
                                                %{--<li><a onclick="document.getElementById('user-admin').submit();  return false;">Tornar admin</a></li>--}%
                                    <li><a id="make-admin" onclick="manageAdmin(this.id);" >Tornar admin</a></li>
                                </g:if>
                                <g:else>
                                    <li><a id="remove-admin" onclick="manageAdmin(this.id);">Remover admin</a></li>
                                </g:else>
                            </ul>
                        </div>
                    </div>
                </g:each>
            <g:each var="groupExportedResources" in="${group.groupExportedResources}">
                <div class="card white col l3 pull-l4 hoverable">
                    <div class="card-image">
                        <img alt="${groupExportedResources.exportedResource.name}" src="/published/${groupExportedResources.exportedResource.processId}/banner.png">
                    </div>
                    <div class="card-content">
                        dasd
                    </div>
                </div>
            </g:each>

        </div>

</div>


<script src="http://code.jquery.com/ui/1.10.4/jquery-ui.js"></script>
<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">

<script>
    function deleteGroupUser(){
        $.ajax({
            type:'POST',
            url:"/user-group/delete",
            data: {
                userGroupId: $("#user-group-id").val()
            },
            success: function(data) {
                console.log(data);
                console.log("success");
                window.location.reload();
            }
        })
    }

    function manageAdmin(option){
        $.ajax({
            type:'POST',
            url:"/user-group/manageAdmin",
            data: {
                userGroupId: $("#user-group-id").val(),
                option: option
            },
            success: function(data) {
                console.log(data);
                console.log("success");
                window.location.reload();
            }
        })
    }


</script>

<script>

    $("#search-user").autocomplete({
        source: function(request,response){
            $.ajax({
                type:'GET',
                url:"/user/autocomplete",
                data: {
                    query: request.term,
                    group: ${group.id}
                },
                success: function(data) {
                    response(data);
                }
            })
        },
        select: function(event, ui) {
            event.preventDefault();
            $("#user-id").val(ui.item.value);

        },
        focus: function(event, ui) {
            event.preventDefault();
            $(this).val(ui.item.label);
        },
        messages: {
            noResults: '',
            results: function() {}
        },
        minLength: 3
    });

</script>

</body>
</html>