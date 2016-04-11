/**
 * Created by Rener on 11/04/16.
 */

$(document).ready(function() {
    //$('#game-stat')
    fillTable(2);

    function fillTable(resourceId) {
        console.log("inside the function");
        $.ajax({
            url: '/exported-resource/_table.gsp',
            type: 'POST',
            data: { resourceId: resourceId },
            success: function(data, status) {
                console.log($('.game-stat'));
                console.log(data);
                $('.game-stat').html(data);
            },
            error: function(data) {
                console.log("error.");
            }
        });
    }
});