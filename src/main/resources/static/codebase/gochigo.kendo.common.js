/**
 * SystemName 을 반환
 */
function fnGetSystemName() {
	if (opener != null) {
		return opener._systemName;
	} else {
		return _systemName === undefined ? '' : _systemName;
	}
}