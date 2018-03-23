var initSelectBox = function(selector, options,selectCallback) {
    function clearBubble(e) {
        if (e.stopPropagation) {
            e.stopPropagation();
        } else {
            e.cancelBubble = true;
        }

        if (e.preventDefault) {
            e.preventDefault();
        } else {
            e.returnValue = false;
        }
    }
    var $container = $(selector);
    for(var i=0;i<options.length;i++){
    	var option = options[i];
    	$container.append($('<div class="fileDiv select-item" data-value='+option["value"]+'>'+option["text"]+'</div>'));
    }
    //  框选事件
    $container
        .on('mousedown', function(eventDown) {
            //  设置选择的标识
            var isSelect = true;
            //  创建选框节点
            var $selectBoxDashed = $('<div class="select-box-dashed"></div>');
            $('body').append($selectBoxDashed);
            //  设置选框的初始位置
            var startX = eventDown.x || eventDown.clientX;
            var startY = eventDown.y || eventDown.clientY;
            $selectBoxDashed.css({
                left: startX,
                top : startY
            });
            //  根据鼠标移动，设置选框宽高
            var _x = null;
            var _y = null;
            //  清除事件冒泡、捕获
            clearBubble(eventDown);
			$(selector).off('mousemove');
            //  监听鼠标移动事件
            $(selector).on('mousemove', function(eventMove) {
                //  设置选框可见
                $selectBoxDashed.css('display', 'block');
                //  根据鼠标移动，设置选框的位置、宽高
                _x = eventMove.x || eventMove.clientX;
                _y = eventMove.y || eventMove.clientY;
                //  暂存选框的位置及宽高，用于将 select-item 选中
                var _left   = Math.min(_x, startX);
                var _top    = Math.min(_y, startY);
                var _width  = Math.abs(_x - startX);
                var _height = Math.abs(_y - startY);
                $selectBoxDashed.css({
                    left  : _left,
                    top   : _top,
                    width : _width,
                    height: _height
                });
                //  遍历容器中的选项，进行选中操作
                $(selector).find('.select-item').each(function() {
                    var $item = $(this);
                    var itemX_pos = $item.prop('offsetWidth') + $item.offset().left;
                    var itemY_pos = $item.prop('offsetHeight') + $item.offset().top;
                    //  判断 select-item 是否与选框有交集，添加选中的效果（ temp-selected ，在事件 mouseup 之后将 temp-selected 替换为 selected）
                    var condition1 = itemX_pos > _left;
                    var condition2 = itemY_pos > _top;
                    var condition3 = $item.offset().left < (_left + _width);
                    var condition4 = $item.offset().top < (_top + _height);
                    if (condition1 && condition2 && condition3 && condition4) {
                        $item.addClass('temp-selected');
                    } else {
                        $item.removeClass('temp-selected');
                    }
                });
                //  清除事件冒泡、捕获
                clearBubble(eventMove);
            });
			$(selector).off('mouseup');
            $(selector).on('mouseup', function() {
                $(selector).off('mousemove');
                $(selector)
                    .find('.select-item.temp-selected')
                    .removeClass('temp-selected')
                    .addClass('selected');
                $selectBoxDashed.remove();

                if (selectCallback) {
                    selectCallback(getValues());
                }
            });
        })
        //  点选切换选中事件
        .on('click', '.select-item', function() {
            if ($(this).hasClass('selected')) {
                $(this).removeClass('selected');
            } else {
                $(this).addClass('selected');
            }
			
			if (selectCallback) {
                selectCallback(getValues());
            }
        })
        //  点选全选全不选
        .on('click', '.toggle-all-btn', function() {
            if ($(this).attr('data-all')) {
                $(this).removeAttr('data-all');
                $container.find('.select-item').removeClass('selected');
            } else {
                $(this).attr('data-all', 1);
                $container.find('.select-item').addClass('selected');
            }
        });
		
		function getValues(){
			var selects = $(selector).find('.select-item.selected');
			var values = [];
			for (var i = 0; i < selects.length; i++) {
				values.push(selects.eq(i).data('value')); // 将文本框的值添加到数组中
			}
			return values;
		}
		$container.getValues = getValues;
		
		$container.setValues = function(options){
			for(var i=0;i<options.length;i++){
				$(selector).find('div[data-value='+options[i]+']').addClass('selected');
			}
		}
		
		$container.reset =  function(){
			$(selector).find(".toggle-all-btn").attr('data-all', 1).click();
		}
		
		return $container;
};
