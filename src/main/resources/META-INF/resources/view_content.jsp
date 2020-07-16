<%@ include file="/init.jsp" %>




<%

String redirect = ParamUtil.getString(request, "redirect");


long assetEntryId = ParamUtil.getLong(renderRequest, "assetEntryId");
String type = ParamUtil.getString(renderRequest, "assetRendererType");
String entryClassName = ParamUtil.getString(renderRequest, "entryClassName");

AssetRendererFactory<?> assetRendererFactory = AssetRendererFactoryRegistryUtil.getAssetRendererFactoryByClassName(entryClassName);

AssetEntry assetEntry = assetRendererFactory.getAssetEntry(assetEntryId);

long assetEntryVersionId = ParamUtil.getLong(renderRequest, "assetEntryVersionId");
AssetRenderer<?> assetRenderer = assetRendererFactory.getAssetRenderer(assetEntryVersionId, AssetRendererFactory.TYPE_LATEST);

renderRequest.setAttribute(WebKeys.WORKFLOW_ASSET_PREVIEW, Boolean.TRUE);

portletDisplay.setShowBackIcon(true);
portletDisplay.setURLBack(redirect);

renderResponse.setTitle(assetRenderer.getTitle(locale));

%>

<c:if test="<%= assetEntry != null %>">
	<liferay-asset:asset-display
		assetEntry="<%= assetEntry %>"
		assetRenderer="<%= assetRenderer %>"
		assetRendererFactory="<%= assetRendererFactory %>"
		
	/>


	<%
	String viewInContextURL = assetRenderer.getURLViewInContext(liferayPortletRequest, liferayPortletResponse, null);
	%>

	<c:if test="<%= viewInContextURL != null %>">
		<div class="asset-more">
			<aui:a href="<%= viewInContextURL %>"><liferay-ui:message key="view-in-context" /> &raquo;</aui:a>
		</div>
	</c:if>

</c:if>