<%@ page import="grails.util.Environment" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <link rel="shortcut icon" href="${assetPath(src: 'favicon.png')}">
        <!-- Let browser know website is optimized for mobile -->
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <meta name="theme-color" content="#5D4037">
        <!-- Import Google Icon Font -->
        <link href="http://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <!-- Import materialize.css -->
        <link type="text/css" rel="stylesheet" href="${resource(dir: "css", file: "materialize.css")}" media="screen,projection"/>
        <!-- Import custom styles -->
        <link type="text/css" rel="stylesheet" href="${resource(dir: "css", file: "style.css")}"/>

        <link rel="stylesheet" type="text/css" href="//cdn.jsdelivr.net/jquery.slick/1.5.9/slick.css"/>

        <link rel="stylesheet" type="text/css" href="//cdn.jsdelivr.net/jquery.slick/1.5.9/slick-theme.css"/>

        <link rel="stylesheet" href="${resource(dir: 'css', file: 'introjs.min.css')}" />

        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">

        <style>
            .slick-prev:before,
            .slick-next:before {
                font-size: 20px;
                line-height: 1;
                opacity: .75;
                color: black;
            }
            .slick-slide img {
                display: inline-block;
            }
        </style>

        %{--<!-- js -->--}%
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>

        %{--<script type="text/javascript" src="${resource(dir: 'js', file: 'intro.js')}"></script>--}%

        <g:javascript src="materialize.min.js"/>

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/Swiper/3.3.1/css/swiper.css">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/Swiper/3.3.1/js/swiper.jquery.js"></script>

        <title><g:layoutTitle default="REMAR"/></title>

        <g:layoutHead/>
    </head>
    <body>
        <g:layoutBody/>
        %{--<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>--}%

        <script type="text/javascript" src="${resource(dir: 'js', file: 'intro.js')}"></script>

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/rateYo/2.0.1/jquery.rateyo.min.css">

        <script src="https://cdnjs.cloudflare.com/ajax/libs/rateYo/2.0.1/jquery.rateyo.min.js"></script>

        <script>
            $(document).ready(function() {
                $(".button-collapse").sideNav();

                $('.dropdown-button').dropdown({
                    alignment: 'left'
                });

                $('.collapsible').collapsible();

                $('.tooltipped').tooltip({delay: 50});

                $('select').material_select();

            });

            function startWizard(){
                if(window.innerWidth > 992) { //desktop
                    introJs().start();
                }
            }
        </script>
        <g:if test="${Environment.current != Environment.DEVELOPMENT}">
            <script>

                (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
                            (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
                        m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
                })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

                ga('create', 'UA-47156714-2', 'auto');
                ga('send', 'pageview');
            </script>
        </g:if>
    </body>
</html>
