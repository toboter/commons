/*
 * jQuery File Upload Plugin JS Example
 * https://github.com/blueimp/jQuery-File-Upload
 *
 * Copyright 2010, Sebastian Tschan
 * https://blueimp.net
 *
 * Licensed under the MIT license:
 * https://opensource.org/licenses/MIT
 */

/* global $, window */

$(function () {
    'use strict';

    // Initialize the jQuery File Upload widget:
    $('#fileupload').fileupload({
        // Uncomment the following to send cross-domain cookies:
        //xhrFields: {withCredentials: true},
        url: '/subjects.json',
        paramName: 'subject[file]',
        filesContainer: $('div.files'),
        uploadTemplateId: null,
        downloadTemplateId: null,
        previewMaxWidth: 40,
        previewMaxHeight: 40,
        previewCrop: true,
        disableVideoPreview: true,
        disableAudioPreview: true,
        uploadTemplate: function (o) {
            var rows = $();
            $.each(o.files, function (index, file) {
                var row = $('<a class="list-group-item template-upload fade">' +
                                '<div class="media-left">' +
                                    '<span class="preview"></span>' +
                                '</div>' +
                                '<div class="media-body">' +
                                    '<h4 class="media-heading">' +
                                        '<span class="name"></span>' +
                                        '<small><span class="pull-right size">Processing...</span></small>' +                      
                                    '</h4>' +
                                    '<div class="error"></div>' +
                                    '<div class="progress progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0">' +
                                        '<div class="progress-bar progress-bar-success" style="width:0%;"></div>' +
                                    '</div>' +
                                '</div>' +
                                '<div class="media-right" style="width:15%;">' +
                                        (!index && !o.options.autoUpload ?
                                            '<button class="start btn btn-primary btn-sm pull-right" style="margin-left:3px;" disabled><i class="glyphicon glyphicon-upload"></i></button>' : '') +
                                        (!index ? '<button class="cancel btn btn-warning btn-sm pull-right"><i class="glyphicon glyphicon-ban-circle"></i></button>' : '') +         
                                '</div>' +
                            '</a>');
                row.find('.name').text(file.name);
                row.find('.size').text(o.formatFileSize(file.size));
                if (file.error) {
                    row.find('.error').text(file.error);
                }
                rows = rows.add(row);
            });
            return rows;
        },
        downloadTemplate: function (o) {
            var rows = $();
            $.each(o.files, function (index, file) {
                var row = $('<a class="list-group-item template-download fade">' +
                                '<div class="media-left">' +
                                    '<span class="preview"></span>' +
                                '</div>' +
                                '<div class="media-body">' +
                                    '<h4 class="media-heading">' +
                                        '<span class="name"></span>' +
                                        '<small><span class="pull-right size"></span></small>' +                      
                                    '</h4>' +
                                    (file.error ? '<div class="error"></div>' : '') +
                                '</div>' +
                                '<div class="media-right" style="width:15%;">' +
                                    (file.error ? '<i class="glyphicon glyphicon-remove-sign pull-right"></i>' : '<i class="glyphicon glyphicon-ok-sign pull-right"></i>') +
                                '</div>' +
                            '</a>');
                row.find('.size').text(o.formatFileSize(file.size));
                if (file.error) {
                    row.find('.name').text(file.name);
                    row.find('.error').text(file.error);
                } else {
                    row.find('.name').text(file.name);
                    if (file.thumbnailUrl) {
                        row.find('.preview').append(
                            $('<img>').prop('src', file.thumbnailUrl)
                        );
                    }
                    row.find('div.media-left').parent()
                        .attr('data-gallery', '')
                        .attr('data-remote', 'true')
                        .prop('href', file.url);
                    row.find('button.delete')
                        .attr('data-type', file.delete_type)
                        .attr('data-url', file.delete_url);
                }
                rows = rows.add(row);
            });
            return rows;
        }
    });

    // Enable iframe cross-domain access via redirect option:
    $('#fileupload').fileupload(
        'option',
        'redirect',
        window.location.href.replace(
            /\/[^\/]*$/,
            '/cors/result.html?%s'
        )
    );

    // Load existing files:
    // $('#fileupload').addClass('fileupload-processing');
    // $.ajax({
    //     // Uncomment the following to send cross-domain cookies:
    //     // xhrFields: {withCredentials: true},
    //     url: $('#fileupload').fileupload('option', 'url'),
    //     dataType: 'json',
    //     context: $('#fileupload')[0]
    // }).always(function () {
    //     $(this).removeClass('fileupload-processing');
    // }).done(function (result) {
    //     $(this).fileupload('option', 'done')
    //         .call(this, $.Event('done'), {result: result});
    // });
});