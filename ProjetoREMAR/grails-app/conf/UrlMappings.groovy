class UrlMappings {

	static mappings = {
        "/$controller/$action?/$id?(.$format)?"{
            constraints {
                // apply constraints here
            }
        }

        // begin index mappings
        "/"(controller:'index')
        "/dashboard"(controller: "index", action: "dashboard")
        // end index mappings
        "/login"(view: "login/auth")
        // begin user mappings
        '/user/email/confirm'(controller: 'user',action: 'confirmNewUser')
        '/user/newpassword/confirm'(controller: 'user',action: 'createPassword')
        '/user/confirmation'(view: '/static/emailuser')
        // end user mappings

        // begin password mappings
        //noinspection GroovyAssignabilityCheck
        name resetPassword: "/password/reset"(view: "/static/forgottenPassword")

        // end password mappings

        // begin Process API endpoints
        "/process/task/complete/$id"(controller:"process", action:"completeTask")
        "/process/task/resolve/$process/$id"(controller:"process", action:"resolveTask")
        "/process/task/delegate/$process/$id"(controller:"process", action:"delegateTasks")
        // end Process API endpoints

        // begin Game API endpoints
        "/game/review/$id/$status?"(controller:"game", action:"review")
        // end Game API endpoints


        "500"(view:'/error')
	}
}
