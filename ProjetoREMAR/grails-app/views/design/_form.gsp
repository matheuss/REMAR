<!DOCTYPE HTML>
<%@ page import="projetoremar.Design" %>
<%@page expressionCodec="raw" %>


<head xmlns="http://www.w3.org/1999/html">
    <asset:javascript src="uploadr.manifest.js"/>
    <asset:javascript src="uploadr.demo.manifest.js"/>
    <asset:stylesheet href="uploadr.manifest.css"/>
    <asset:stylesheet href="uploadr.demo.manifest.css"/>
    <g:javascript library='jquery' plugin="jquery" />
    <script type="text/javascript" src="../../assets/javascripts/imagePreview.js"></script>

</head>



<fieldset>
    <legend>Upload de Imagens</legend>
    <div>
    <g:uploadForm controller="design" action="ImagesManager">
        <div>
            <img id="iconePreview" style="width: 100px; height: 100px;" />
        </div>

        <input type="file" name="icone" id="icone" />

        <div style="font-size:0.8em; margin: 1.0em;">
            <p>Escolha um icone para seu jogo.
                </p>

        </div>

        </div>
        <div>
            <img id="openingPreview" style="width: 100px; height: 100px;" />
        </div>


        <input type="file" name="opening" id="opening" />
        <div style="font-size:0.8em; margin: 1.0em;">
            <p>Escolha uma imagem de abertura.
            </p>

        </div>

        <img id="backgroundPreview" style="width: 100px; height: 100px;" />
        <input type="file" name="background" id="background"/>
        <div style="font-size:0.8em; margin: 1.0em;">
           <p> Escolha uma imagem de fundo.
           </p>

        </div>

    </g:uploadForm>

    <input type="submit" name="upload" value="Upload!"/>

</fieldset>

