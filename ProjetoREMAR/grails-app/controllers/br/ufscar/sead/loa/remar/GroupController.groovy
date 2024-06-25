package br.ufscar.sead.loa.remar

import br.ufscar.sead.loa.propeller.Propeller
import br.ufscar.sead.loa.remar.statistics.StatisticFactory
import br.ufscar.sead.loa.remar.statistics.ChallengeStats
import com.mongodb.Block
import grails.converters.JSON
import org.apache.commons.lang.RandomStringUtils
import org.bson.Document

import org.springframework.transaction.annotation.Transactional

class GroupController {

    def springSecurityService

    def beforeInterceptor = [action: this.&check, only: ['list', 'show']]

    private check() {
        if (!session.user) {
            log.debug "Logout: session.user is NULL !"
            redirect controller: "logout", action: "index"
            return false
        }
    }

    def list() {
        def model = [:]

        model.groupsIOwn = Group.findAllByOwner(session.user)
        model.groupsIBelong = UserGroup.findAllByAdminAndUser(false, session.user).group

        render view: "list", model: model
    }

    def admin() {
        def model = [:]

        model.groupsIOwn = Group.findAllByOwner(session.user)
        model.groupsIAdmin = UserGroup.findAllByAdminAndUser(true, session.user).group

        render view: "admin", model: model
    }

    def create(){
        def groupInstance = new Group()

        params.groupname = params.groupname.trim().replaceAll(" +"," ")

        if (!params.groupname || params.groupname.allWhitespace) {
            request.message = "blank_name"
            render view: "new"
            return
        } else if (params.groupname && Group.findByName(params.groupname)) {
            request.message = "name_already_exists"
            render view: "new"
            return
        } else {
            groupInstance.name = params.groupname
            groupInstance.owner = session.user
            groupInstance.token = RandomStringUtils.random(10, true, true)

            groupInstance.save flush: true, failOnError: true
        }

        redirect action: "show", id: groupInstance.id
    }

    def show(){
        def group = Group.findById(params.id)
        def userGroup = UserGroup.findByUserAndGroup(session.user,group)

        session.group = group

        if(group.owner.id == session.user.id || userGroup){
            def groupExportedResources = group.groupExportedResources.toList()
            render(view: "show", model: [group: group, groupExportedResources: groupExportedResources, userIsAdmin: (group.owner.id == session.user.id || userGroup?.admin)])
            response.status = 200
        }else
            render status: 401, view: "../401"
    }

    def isLogged() {
        println params
        if (params.choice != "null") {
            if (params.choice == "offline") {
                println "ok"
                render status: 200
            } else if (params.choice == "login") {
                println "login in"
                springSecurityService.reauthenticate(params.username, params.password)
                if (springSecurityService.isLoggedIn()) {
                    session.user = springSecurityService.getCurrentUser()
                    println "logged!"
                    render status: 200
                } else {
                    println "didnt find user"
                    render status: 401, template: "stats/login"
                }
            }
        } else {
            render status: 401, template: "stats/login"
        }
    }

    def stats() {
        def group = Group.findById(params.id)
        def isMultiple = false //Variável para determinar se um jogo é multiplo ou não
        def hasContent = false //Variável para determinar se foi passado conteúdo à view
        def gameLevel = [:] //Usado apenas para games com multiplos levels

        if (session.user.id == group.owner.id || UserGroup.findByUserAndAdmin(session.user, true)) {
            def exportedResource = ExportedResource.findById(params.exp)
            def process = Propeller.instance.getProcessInstanceById(exportedResource.processId as String, session.user.id as long)
            if (exportedResource) {
                def allUsersGroup = UserGroup.findAllByGroup(group).user
                def queryMongo
                try {
                    queryMongo = MongoHelper.instance.getStats("challengeStats", exportedResource.id as Integer, allUsersGroup.id.toList())

                    //Array que guardará os stats a serem enviados par a view
                    def allStats = []

                    //Array que guardará os stats especificos a serem guardados no allStats
                    def _stat

                    for (int i = 0; i < queryMongo.size(); i++) {
                        //Find em todos os usuários do grupo
                        def user = allUsersGroup.find { user -> user.id == queryMongo.get(i).userId || group.owner.id == queryMongo.get(i).userId }
                        _stat = [[user: user]]

                        queryMongo.get(i).stats.each {
                            //Popula um map gameLevel para enviar à view.
                            //Keys: numeros das fases no propeller (apenas as personalizadas)
                            //Values: respectivos nomes das fases no propeller (apenas as personalizadas)

                            if (it.containsKey("levelId")) {
                                gameLevel.put(it.levelId, [name: it.levelName, size: it.levelSize])
                                //Se encontrar um gameLevel, então significa que o jogo é do tipo multiplo
                                isMultiple = true
                            }
                            _stat.push([challengeId: it.challengeId, win: it.win, gameSize: it.levelSize, gameLevel: it.levelId])
                        }
                        // Ao fim de cada acumulo de estatistica de um respectivo usuario, dá-se o push dele e suas estatisticas no array allStats
                        allStats.push(_stat)
                        hasContent = true
                    }

                    // Se o jogo for multiplo, o array de estatísticas já obtido anteriormente precisa ser rearranjado.
                    // Para melhor manipulação na view, este array se tornará um map de maps.
                    // Main Map: key = user ids // values =  conjunto de estatisticas do usuario
                    // Sub Maps: key = numero da fase // values = estatisticas da respectiva fase
                    if (isMultiple) {

                        // Remove os usuários de cada array presente no array allStats
                        allStats.each {
                            it.remove(0)
                        }

                        // TreeMap (chave de ordenação nome do usuário)

                        def userStatsMap = new TreeMap(new Comparator() {
                            @Override
                            int compare(Object o1, Object o2) {
                                User u1 = ((ArrayList) o1).get(0).user
                                User u2 = ((ArrayList) o2).get(0).user

                                return u1.firstName.compareToIgnoreCase(u2.firstName)
                            }
                        })

                        // Novo percorrer da consulta para repopular os usuários, considerando agora o tipo multiplo

                        for (int i = 0; i < queryMongo.size(); i++) {
                            def statsMap = [:]
                            def user = allUsersGroup.find { user -> user.id == queryMongo.get(i).userId || group.owner.id == queryMongo.get(i).userId }
                            _stat = [[user: user]]

                            // Coleção com closure passado para remover os gameLevel das estatísticas, de forma que ele seja, agora, uma chave e não um atributo
                            def removeGI = allStats.get(i).collect() {
                                def tempMap = [:]
                                def gInd = it.gameLevel
                                it.remove("gameLevel")
                                tempMap.put(gInd, it)
                                tempMap // retorno do collect()
                            }

                            //Para cada numero de fase, busca-se na coleção se existe aquela chave, e cria-se um novo hash (combinando repetições), que será:
                            //Key = numero da fase
                            //Value = estatísticas da fase
                            gameLevel.keySet().each() {
                                def gInd = it
                                def indexList = removeGI.findAll() { it.containsKey(gInd) }
                                def valuesList = indexList.collect() { it.get(gInd) }
                                statsMap.put(gInd, valuesList)
                            }

                            // Por fim cria-se um hash cuja key será o id do usuário, e values todos seus stats
                            userStatsMap.put(_stat, statsMap)
                            hasContent = true
                        }

                        render view: "stats", model: [userStatsMap: userStatsMap, group: group, exportedResource: exportedResource,
                                                      gameLevel   : gameLevel, isMultiple: isMultiple, hasContent: hasContent]
                    } else {

                        // Ordena a lista antes de envio para a visão (chave de ordenação - nome do usuário)

                        Collections.sort(allStats, new Comparator() {
                            @Override
                            public int compare(Object o1, Object o2) {
                                User u1 = ((ArrayList) o1).get(0).user;
                                User u2 = ((ArrayList) o2).get(0).user;

                                return u1.firstName.compareToIgnoreCase(u2.firstName)
                            }
                        });

                        // Se não for multiplo, manda-se apenas os atributos necessários

                        render view: "stats", model: [allStats: allStats, group: group, exportedResource: exportedResource, isMultiple: isMultiple, hasContent: hasContent]
                    }

                    // Descomentar caso desejar mostrar os membros SEM estatísticas
                    /*if(!allStats.empty) {
                        allUsersGroup.each { member ->
                            if (!allStats.find { stat -> stat.get(0) != null && stat.get(0).user.id == member.id }) {
                                allStats.push(member)
                            }

                        }
                    }*/

                    //allStats.sort({it.get(0).user.getName()})

                } catch (NullPointerException e) {
                    System.err.println(e.getClass().getName() + ": " + e.getMessage());
//                    redirect(action: 'stats', id: params.id)
                }
            }else{
                render status: 401, view: "../401"
            }
        }else {
            println "forbbiden"
            render status: 401, view: "../401"
        }
    }

    def userStats() {

        def user = User.findById(params.id)
        def exportedResource = ExportedResource.findById(params.exp)

        // Os parâmetros abaixo são recebidos apenas quando o jogo é do tipo Multiplo
        def gameLevel = params.level; // Numero da fase
        def levelName = params.levelName; // Nome da fase

        if (user) {
            def queryMongo = MongoHelper.instance.getStats('challengeStats', params.exp as int, user.id)
            def allStats = []
            queryMongo.forEach(new Block<Document>() {
                @Override
                void apply(Document document) {
                    document.stats.each {

                        //Verificação realizada para filtrar, tambem, pelo gameLevel quando o jogo é multiplo

                        if (gameLevel == null || it.levelId == gameLevel as int) {
                            if (it.challengeId == params.challenge as int) {

                                // Estratégia utilizada para padronizar a população de dados e o respectivo retorno (economia de ifs e switches)
                                StatisticFactory factory = StatisticFactory.instance;
                                ChallengeStats statistics = factory.createStatistics(it.challengeType as String)

                                def data = statistics.getData(it);

                                allStats.push(data)
                            }
                        }

                    }
                }
            })

            render view: "userStats", model: [allStats : allStats, user: user, exportedResource: exportedResource,
                                              levelName: levelName]
        }
    }

    @Transactional
    def delete() {
        def group = Group.findById(params.id)

        if (group.owner.id == session.user.id) {
            // Delete all user-group relationships from database
            List<UserGroup> userGroups = UserGroup.findAllByGroup(group)
            for (int i = 0; i < userGroups.size(); i++)
                userGroups.get(i).delete()

            group.delete flush: true
            redirect(action: "list")
        } else
            render (status: 401, view: "../401")
    }

    @Transactional
    def update() {
        def group = Group.findById(params.groupid)
        def errors = [
                blank_name: false,
                name_already_exists: false,
                blank_token: false
        ]

        if (group == null) {
            println "GroupController.update() could not find group with id: " + params.groupid
            return
        }

        if (!params.groupname || params.groupname.allWhitespace) {
            errors.blank_name = true
        } else if (params.groupname && Group.findByName(params.groupname)) {
            errors.name_already_exists = true
        } else {
            group.name = params.groupname
        }

        if (!params.grouptoken || params.grouptoken.allWhitespace) {
            errors.blank_token = true
        } else {
            group.token = params.grouptoken
        }

        group.save flush: true
        request.error = errors

        forward action: "edit", id: params.groupid
    }

    def edit() {
        def group = Group.findById(params.id)

        def usersInGroup = []
        def usersNotInGroup = []
        session.groupid = params.id

        for (user in User.list().sort {it.getName().toLowerCase()}) {
            def userGroup = UserGroup.findByUserAndGroup(user, group)
            if (userGroup)
                usersInGroup.add([
                    userInstance: user,
                    isAdmin: userGroup.admin
                ])
            else
                usersNotInGroup.add(user)
        }
        render view: "edit", model: [group: group, usersInGroup: usersInGroup, usersNotInGroup: usersNotInGroup]
    }

    def addUsers() {
        def group = Group.findById(session.groupid)

        try {
            for (id in JSON.parse(params.users)) {
                def user = User.findById(id)
                def userGroup = new UserGroup(user: user, group: group)
                userGroup.save flush: true
            }
        } catch (e) {
            render (status: 410, text: "ERROR: Failed adding user from group")
            return
        }

        render (status: 200)
    }

    def removeUsers() {
        def group = Group.findById(session.groupid)

        try {
            for (id in JSON.parse(params.users)) {
                def user = User.findById(id)
                def userGroup = UserGroup.findByUserAndGroup(user, group)
                userGroup.delete flush: true
            }
        } catch (e) {
            render (status: 410, text: "ERROR: Failed removing user from group")
            return
        }

        render (status: 200)
    }

    def toggleUserAdminStatus() {
        def group = Group.findById(session.groupid)

        try {
            def user = User.findById(params.userid)
            def userGroup = UserGroup.findByUserAndGroup(user, group)

            userGroup.admin = !userGroup.admin
            userGroup.save flush:true
        } catch (e) {
            render (status: 410, text: "ERROR: Failed toggling user admin status")
        }
    }

    def leaveGroup() {
        User user = session.user
        def group = Group.findById(params.id)
        def userGroup = UserGroup.findByUserAndGroup(user, group)
        userGroup.delete flush: true

        redirect status: 200, action: "list"
    }

    def addUserAutocomplete() {
        def group = Group.findById(params.groupid)

        if (group.owner.id == session.user.id || UserGroup.findByUserAndGroupAndAdmin(session.user, group, true)) {
            def user = User.findById(params.userid)
            println user
            log.debug("Attempting to add user " + params.userid + " to group " + params.groupid)
            if (user) {
                if (!UserGroup.findByUserAndGroup(user, group) && !(group.owner.id == user.id)) {
                    def userGroup = new UserGroup()
                    userGroup.group = group
                    userGroup.user = user
                    userGroup.save flush: true

                    log.debug("Success!")
                    render status: 200, template: "newUserGroup", model: [userGroup: userGroup]
                } else {
                    log.debug("Failed! User is already in group.")
                    render status: 403, text: "Usuário já pertence ao grupo."
                }
            } else {
                log.debug("Failed! User not found.")
                render status: 404, text: "Usuário não encontrado."
            }
        }
    }

    def addUserByToken() {
        if (params.membertoken != "") {
            def userGroup = new UserGroup()
            def group = Group.findByToken(params.membertoken)
            if (group) {
                def user = User.findById(session.user.id)
                if (!UserGroup.findByUserAndGroup(User.findById(user.id), group)) {
                    userGroup.group = group
                    userGroup.user = user
                    userGroup.save flush: true
                    redirect action: 'show', id: group.id
                } else {
                    flash.message = "Você já pertence a este grupo."
                    redirect action: "list"
                }

            } else {
                flash.message = "Grupo não encontrado"
                redirect action: "list"
            }
        } else {
            flash.message = "Grupo não encontrado"
            redirect action: "list"
        }
    }

    def addUserById() {
        def group = Group.findById(params.groupId)
        def user = User.findById(params.userId)
        def userGroup = new UserGroup()

        if (user) {
            userGroup.group = group
            userGroup.user = user
            userGroup.save flush: true
        }
    }

    def findGroup() {
        println(params.name)
        def group = Group.findByNameAndOwner(params.name, session.user)
        render group
    }

    def rankUsers() {
        /*
         *  Parâmetros:
         *      id -> identificador do grupo
         *      exp -> identificador do recurso exportado
         */
        println("rankUsers() params: " + params)

        def group = Group.findById(params.groupId)
        def userGroups = UserGroup.findAllByGroup(group)
        def resourceName = ExportedResource.findById(params.exportedResourceId).name
        def resourceRanking = RestHelper.instance.get('http://host.docker.internal:3000/stats/ranking/'+params.exportedResourceId)//chamada para API (devo deixara aqui????)
        def groupRanking = []
        def rankingMax = 10
        def rankingPosition = 0

        for (o in resourceRanking) {
            if (userGroups.find { it.user.id == o.userId } != null) {
                def entry = [:]
                entry.user = User.findById(o.userId)
                entry.score = o.score
                def timestamp = Date.parse("yyyy-MM-dd' 'HH:mm:ss",o.timestamp)
                entry.timestamp = timestamp.format("dd/MM/yyyy HH:mm:ss")
                

                groupRanking.add(entry)
                rankingPosition = rankingPosition + 1

                if (rankingPosition >= rankingMax)
                    break
            }
        }

        render(view: "ranking", model: [ranking: groupRanking, resource: resourceName])
    }
}


