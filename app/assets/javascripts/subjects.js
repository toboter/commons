// http://filer.grandesign.md/
$(document).ready(function() {
  $("#upload-multiple").removeClass('hidden');
  $("#multiple_new_subjects").filer({
    clipBoardPaste: true,
    showThumbs: true,
    addMore: true,
    dragDrop: {},
    changeInput: '<div class="jFiler-input-dragDrop"><div class="jFiler-input-inner"><div class="jFiler-input-icon"><i class="icon-jfi-folder"></i></div><div class="jFiler-input-text"><h3>Click on this box</h3> <span style="display:inline-block; margin: 15px 0">or</span></div><a class="jFiler-input-choose-btn btn-custom blue-light">Browse Files</a></div></div>',
    theme: "dragdropbox",
    uploadFile: {
      url: "/subjects/upload",
      data: {},
      type: 'POST',
      enctype: 'multipart/form-data',
      beforeSend: function(){},
      success: function(data, el){
        var parent = el.find(".jFiler-jProgressBar").parent();
        el.find(".jFiler-jProgressBar").fadeOut("slow", function(){
          $("<div class=\"jFiler-item-others text-success\"><i class=\"fa fa-check-square-o\"></i> Success</div>").hide().appendTo(parent).fadeIn("slow");
        });
        console.log(data);
        // var partial = "<%= j(render :partial => 'subjects/subject', :locals => {subject: data}) %>";
        // parent.parent().parent().parent().parent().delay(2000).fadeOut("slow");
        // $("#uploads").append(partial);
      },
      error: function(el){
        var parent = el.find(".jFiler-jProgressBar").parent();
        el.find(".jFiler-jProgressBar").fadeOut("slow", function(){
          $("<div class=\"jFiler-item-others text-alert\"><i class=\"fa fa-minus-square-o\"></i> Error</div>").hide().appendTo(parent).fadeIn("slow");
        });
      },
      statusCode: null,
      onProgress: null,
      onComplete: null
    },
    templates: {
      box: '<ul class="jFiler-items-list jFiler-items-grid"></ul>',
      item: '<li class="jFiler-item">\
               <div class="jFiler-item-container">\
                 <div class="jFiler-item-inner">\
                   <div class="jFiler-item-thumb">\
                     <div class="jFiler-item-status"></div>\
                     <div class="jFiler-item-thumb-overlay">\
										   <div class="jFiler-item-info">\
											   <div style="display:table-cell;vertical-align: middle;">\
												   <span class="jFiler-item-title"><b title="{{fi-name}}">{{fi-name}}</b></span>\
												   <span class="jFiler-item-others">{{fi-size2}}</span>\
											   </div>\
										   </div>\
									   </div>\
                     {{fi-image}}\
                   </div>\
                   <div class="jFiler-item-assets jFiler-row">\
                     <ul class="list-inline pull-left">\
                       <li>{{fi-progressBar}}</li>\
                     </ul>\
                     <!-- <ul class="list-inline pull-right">\
                       <li><a class="jFiler-item-trash-action"><i class="fa fa-remove"></i></a></li>\
                     </ul> -->\
                   </div>\
                 </div>\
               </div>\
             </li>',
      progressBar: '<div class="bar"></div>',
      itemAppendToEnd: false,
      removeConfirmation: false,
      _selectors: {
        list: '.jFiler-items-list',
        item: '.jFiler-item',
        progressBar: '.bar',
        remove: '.jFiler-item-trash-action',
      }
    }
  });
});