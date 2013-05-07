'use strict'

angular.module('portfolioNgApp')
    .directive 'niPersonaAuth', ['Persona', '$compile', (Persona, $compile) ->

        authTmpl = '<a><img class="persona" ng-click="request()" src="images/plain_sign_in_black.png"></a>'
        userTmpl = """
            <a>{{email}} <span ng-click="signout()" class="button">Sign out</span></a>
        """

        niPersonaAuth =
            template: '<li class="persona"><a>Persona</a></li>'
            restrict: 'M'
            replace: true


        niPersonaAuth.link = (scope, element) ->
            scope.request = ->
                Persona.request()

            scope.signout = ->
                Persona.signout()

            Persona.onStatus scope, (message) ->
                if message.email
                    scope.email = message.email
                    template = userTmpl
                else
                    template = authTmpl

                element.html template

                $compile(element.contents())(scope)

        niPersonaAuth
    ]

angular.module('portfolioNgApp')
    .directive 'niCard', [ ->
        template = """
        <div class="card">
            <h4 class="title">{{card.name}}</h4>
            <img src="http://placehold.it/600x480/&text={{card.name}}">
            <p>{{card.about}}</p>
        </div>
        """
        niCard =
            restrict: 'M'
            replace: true
            template: template
            link: (scope) ->
                if scope.$last
                    $('#cards-list').foundation 'orbit', {
                        bullets: off
                        slide_number: off
                    }

        return niCard
    ]

angular.module('portfolioNgApp')
    .directive 'niMenu', [ ->
        niMenu =
            template: """
                <ul>
                    <li data-ng-repeat="item in tree">
                        <!-- directive: ni-menu-item item -->
                    </li>
                </ul>
            """
            replace: true
            restrict: 'M'
            scope:
                tree: '=niMenu'

        return niMenu
    ]

angular.module('portfolioNgApp')
    .directive 'niMenuItem', ['$compile', 'Menu', ($compile, Menu) ->
        selectMenuElement = (item) ->
            Menu.currentMenu = item
            return

        linker = (scope, elm) ->
            scope.select = selectMenuElement

            if scope.item.children.length
                childitem = $compile('<!-- directive: ni-menu item.children -->')(scope)
                elm.append childitem

        niMenuItem =
            restrict: 'M'
            replace: true
            template: '<span><a ng-href="#!/menu/{{item.id}}/cards" ng-click="select(item)">{{item.name}}</a></span>'
            link: linker

        return niMenuItem
    ]
