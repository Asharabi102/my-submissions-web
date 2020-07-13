<%@ include file="/init.jsp" %>


<%@ taglib uri="http://liferay.com/tld/asset" prefix="liferay-asset" %><%@
taglib uri="http://liferay.com/tld/comment" prefix="liferay-comment" %><%@
taglib uri="http://liferay.com/tld/frontend" prefix="liferay-frontend" %><%@
taglib uri="http://liferay.com/tld/theme" prefix="liferay-theme" %>

<%@ page import="com.liferay.asset.kernel.AssetRendererFactoryRegistryUtil" %><%@
page import="com.liferay.asset.kernel.model.AssetEntry" %><%@
page import="com.liferay.asset.kernel.model.AssetRenderer" %><%@
page import="com.liferay.asset.kernel.model.AssetRendererFactory" %><%@
page import="com.liferay.petra.string.StringPool" %><%@
page import="com.liferay.portal.kernel.util.HtmlUtil" %><%@
page import="com.liferay.portal.kernel.util.StringUtil" %><%@
page import="com.liferay.portal.kernel.util.WebKeys" %><%@
page import="com.liferay.portal.kernel.workflow.WorkflowException" %><%@
page import="com.liferay.portal.kernel.workflow.WorkflowInstance" %><%@
page import="com.liferay.portal.kernel.workflow.WorkflowLog" %>



<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>

<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui" %><%@
taglib uri="http://liferay.com/tld/clay" prefix="clay" %><%@
taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %><%@
taglib uri="http://liferay.com/tld/util" prefix="liferay-util" %>

<%@ page import="com.liferay.portal.kernel.util.ParamUtil" %><%@
page import="com.liferay.portal.workflow.constants.WorkflowWebKeys" %><%@
page import="com.liferay.portal.workflow.portlet.tab.WorkflowPortletTab" %><%@
page import="com.liferay.taglib.servlet.PipingServletResponse" %>

<%@ page import="java.util.List" %>

<%@ page import="javax.portlet.PortletURL" %>





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