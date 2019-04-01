$(function(){
  $('.article_delete').on('click',function(){
    var li = $(this).parent();
    // console.table($(this).parent());
    if(!confirm('sure?')){
      return;
    }

    // $.post( url, data, function(){} )
    $.post('/bulletinboard/article_destroy', {
      id: li.data('id'),
      _csrf: li.data('token')
    }, function(){
      li.fadeOut(800);
    })
  })

  $('.comment_close').on('click',function(){
    var li = $(this).parent();
    if(!confirm('sure?')){
      return;
    }

    // $.post( url, data, function(){} )
    $.post('/bulletinboard/comment_close', {
      id: li.data('id'),
      _csrf: li.data('token')
    }, function(){
      li.fadeOut(800);
    })
  })

  // $('#article_new').on('click',function(){
  //   alert('記事を登録しました');
  // });
});