angular.module 'security.login', ['security.login.toolbar', 'security.login.form']


# render login button or user name
angular.module 'security.login.toolbar', []

angular.module('security.login.toolbar')
    .directive 'loginToolbar', ['security', (security) ->
        directive =
            templateUrl: 'tpl/security/login.toolbar.html'
            restrict: 'E'
            replace: true
            scope: true
            link: ($scope, $el, $attrs, $ctrl) ->
                $scope.login = security.showLogin
                $scope.logout = security.logout
                $scope.isAuthenticated = security.isAuthenticated
                $scope.$watch ->
                    security.currentUser
                , (currentUser) ->
                    $scope.currentUser = currentUser


        return directive
    ]


# render login form and handle login action
angular.module 'security.login.form', []

angular.module('security.login.form')
    .controller 'LoginFormCtrl', [
        '$scope'
        'security'
        ($scope, security) ->
            $scope.user =
                email: 'test'
            $scope.login = ->
                security.login $scope.user
    ]
