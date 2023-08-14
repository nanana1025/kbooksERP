/*************************************************************************
	함수명: selectedMenuId
	설  명: 선택한 메뉴의 인덱스 번호(ID)를 반환하는 함수
	인  자: item객체(kendoMenu onSelect 이벤트의 $(e.item), menu객체(this) )
	리  턴: 메뉴의 id 값
	사용예:
	selectedMenuId($(e.item), this);
***************************************************************************/
function selectedMenuId(item, menu) {
	var menuElement = item.closest(".k-menu"),
	dataItem = menu.options.dataSource,
	index = item.parentsUntil(menuElement, ".k-item").map(function () {
	    return $(menu).index();
	}).get().reverse();

	index.push(item.index());

	for (var i = 0, len = index.length; i < len; i++) {
	    dataItem = dataItem[index[i]];
	    dataItem = i < len-1 ? dataItem.items : dataItem;
	}
	return dataItem.id;
}