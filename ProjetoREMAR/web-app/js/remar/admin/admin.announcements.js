/**
 * Created by lucas pessoa on 11/10/17.
 */

$(document).ready(function() {
    $('#type-announcement').material_select();

    var $table = $('#announcements-table');
    var $tableButtons = $('.toggleable');

    $tableButtons.domDisable();

    $table.pageMe({
        pagerSelector: '#announcements-table-pager',
        activeColor: '#5d4037',
        showPrevNext: true,
        hidePageNumbers: false,
        perPage: 5
    });

    $('#search-announcement').keyup(function () {
        var $el   = $(this);
        var value = $el.val().toLowerCase();

        $table.children('tr').each(function() {
            var $this    = $(this);
            var name     = $this.children('.announcement-name').first().text();
            var nameMatches     = (name.toLowerCase().indexOf(value) !== -1);

            if (!nameMatches) $this.addClass('hidden');
            else $this.removeClass('hidden');
        });

        $table.reloadMe();
    });

    $('.warning-box .btn-flat:nth-child(2)').click(function () {
        $('.warning-box').slideUp(500);
    });

    $('#select-all-checkbox').change(function() {
        var checked = this.checked;

        $('#announcements-table td input[type="checkbox"]').each(function() {
            $(this).prop('checked', checked);
        });

        if (checked) $tableButtons.domEnable();
        else $tableButtons.domDisable();
    });

    $('#announcements-table td input[type="checkbox"]').change(function() {
        var checkedCB = $('#announcements-table input:checkbox:checked').length;
        var totalCB = $('#announcements-table input:checkbox').length;
        var uncheckedCB = totalCB - checkedCB;

        if (!this.checked) {
            // if one box is unchecked after the 'select all checkbox' was checked, uncheck it too
            $('#select-all-checkbox').prop('checked', false);

            if (checkedCB == 0) $tableButtons.domDisable();
        } else {
            // if this is the last unchecked box, check the 'select all checkbox'
            if (uncheckedCB == 0) $('#select-all-checkbox').prop('checked', true);

            if ($tableButtons.attr('disabled') == 'disabled') $tableButtons.domEnable();
        }
    });

    // Função para adicionar um novo anúncio
    $('#saveAnnouncement').on("click",function(){
        var formData = new FormData();

        formData.append('title',$("#title-announcement").val());
        formData.append('body',$("#body-announcement").val());
        formData.append('type',$("#type-announcement").val());

        $.ajax({
            type: 'POST',
            url: GSM.SAVE_URL,
            data: formData,
            processData: false,
            contentType: false,
            success: function (data) {
                location.reload();
                Materialize.toast(GSM.SAVED_MESSAGE, 3000);
            },
            error: function(req, res, err) {
                Materialize.toast(GSM.NOT_SAVED_MESSAGE, 3000);
            }
        });
    });

    $("#saveEditAnnouncement").on("click",function(){
        var id = $("#editAnnouncement").attr("modal-announcement-id");

        var formData = new FormData();
        formData.append('title',$("#title-announcement").val());
        formData.append('body',$("#body-announcement").val());

        $.ajax({
            url: GSM.EDIT_URL + id,
            type: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function (data) {
                console.log(data);
                // Trocar o reload por alterar a td respectiva com o novo valor
                location.reload();
                Materialize.toast(GSM.EDITED_MESSAGE, 3000);
            },
            error: function(req, res, err) {
                console.log(req);
                console.log(res);
                console.log(err);
                Materialize.toast(GSM.NOT_EDITED_MESSAGE, 3000);
            }
        });
    });

    $('a[id^="remove-announcement"]').click(function () {
        var $row = $(this).closest('tr');
        var title = $row.children('.announcement-title').text();
        var id = $row.data('announcement-id');
        $('#warning-box-message').html(
        GSM.REMOVE_WARNING + '<span id="warning-announcement">' + title + '</span> ?');
        $('.warning-box .btn-flat:first-child').unbind().click(function () {
            $.ajax({
                url: GSM.DELETE_URL,
                type: 'post',
                data: {id: id},
                success: function (resp) {
                    $row.remove();
                    $('#announcements-table').reloadMe();
                    Materialize.toast(GSM.REMOVED_MESSAGE, 2000);
                    $('.warning-box').slideUp(500);
                },
                error: function(req, res, err) {
                    Materialize.toast(GSM.NOT_REMOVED_MESSAGE, 2000);
                    $('.warning-box').slideUp(500);
                }
            });
        });
        $('.warning-box').slideDown(500);
    });

    $('a#batch-remove-button').click(function() {
        $('#warning-box-message').html('${message(code: "admin.announcements.warning.batch")}');
        $('.warning-box .btn-flat:first-child').unbind().click(function () {

            var announcementIdList = [];

            $('#announcements-table input:checkbox:checked').closest('tr').each(function() {
                announcementIdList.push($(this).data('announcement-id'));
            });


            $.ajax({
                url: GSM.DELETE_BATCH_URL,
                type: 'get',
                data: {announcementIdList: JSON.stringify(announcementIdList)},
                success: function (resp) {
                    if (resp.length > 0) {
                        $('#announcements-table input:checkbox:checked').closest('tr').each(function() {
                            for (i = 0; i < resp.length; i++) {
                                if ($(this).data('announcement-id') == resp[i]) {
                                    $(this).remove();
                                }
                            }
                        });

                        if (resp.length == announcementIdList.length) {
                            Materialize.toast(GSM.REMOVED_BATCH_MESSAGE, 2000);
                        } else {
                            Materialize.toast(GSM.PARTIALLY_REMOVED_BATCH_MESSAGE, 2000);
                        }
                    }else{
                        Materialize.toast(GSM.NOT_REMOVED_BATCH_MESSAGE, 2000);
                    }

                    $('#announcements-table').reloadMe();

                    $('.warning-box').slideUp(500);
                },
                error: function(req, res, err) {

                    Materialize.toast(GSM.NOT_REMOVED_BATCH_MESSAGE, 2000);
                    $('.warning-box').slideUp(500);
                }
            });
        });
        $('.warning-box').slideDown(500);
    });

    // Abrir modal para edição já com as infos do anúncio
    $('a[id^="edit-announcement"]').click(function () {
        var $row = $(this).closest('tr');
        var id = $row.data('announcement-id');

        $("#edit-title-announcement").addClass("valid");
        $("label[for='"+$("#edit-title-announcement").attr('id')+"']").addClass("active");

        $("#edit-title-announcement").val($row.find('td').eq(1).text());
        $("#editAnnouncement").attr("modal-announcement-id", id);
    });
});

$.fn.domDisable = function() {
    this.attr('disabled', 'disabled');
};

$.fn.domEnable = function() {
    this.removeAttr('disabled');
};