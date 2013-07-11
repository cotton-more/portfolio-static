angular.module('security.service', [])
    .factory 'security', [
        '$http'
        '$q'
        '$templateCache'
        '$rootScope'
        '$controller'
        '$compile'
        ($http, $q, $templateCache, $rootScope, $ctrl, $compile) ->

            loginDialog = null

            openLoginDialog = ->
                if loginDialog
                    throw new Error 'Login dialog is already open'

                templatePromise = $http.get('coffee/security/login.form.html',
                    cache: $templateCache
                ).then((response) ->
                    $form = $ response.data
                    $form.addClass 'reveal-modal small'

                    $scope = $rootScope.$new()
                    ctrl = $ctrl 'LoginFormCtrl', '$scope': $scope
                    $form.data('ngController', ctrl)
                    $compile($form)($scope)

                    $form.appendTo 'body'
                    loginDialog = $form.foundation 'reveal', 'open'
                )


            closeLoginDialog = ->
                if loginDialog
                    loginDialog.foundation 'reveal', 'close'
                    loginDialog = null


            service =
                currentUser:
                    email: null


            service.checkUser = ->
                request = $http.get '/users/email'
                request.then (response) ->
                    service.currentUser = response.data


            service.isAuthenticated = ->
                return !!service.currentUser.email


            service.showLogin = ->
                openLoginDialog()


            service.login = (user) ->
                console.log user
                request = $http.post '/users/login', user

                request.then (response) ->
                    console.log response
                    service.currentUser = response.data
                    if service.isAuthenticated()
                        closeLoginDialog()


            service.logout = ->
                request = $http.post '/users/logout'
                request.then ->
                    service.currentUser.email = null


            return service
    ]
