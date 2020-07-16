<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet"%>
<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui"%>
<%@ taglib uri="http://liferay.com/tld/portlet" prefix="liferay-portlet"%>
<%@ taglib uri="http://liferay.com/tld/theme" prefix="liferay-theme"%>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui"%>
<%@ taglib uri="http://liferay.com/tld/frontend" prefix="liferay-frontend" %>
<%@ taglib uri="http://liferay.com/tld/security" prefix="liferay-security" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.liferay.portal.kernel.util.ParamUtil" %>
<%@ page import="com.liferay.portal.kernel.util.HtmlUtil" %>
<%@ page import="com.liferay.portal.kernel.util.WebKeys" %>
<%@ page import="com.liferay.petra.string.StringPool" %>
<%@ page import="com.rge.forms.workflow.submissions.dto.WorkflowDTO" %>
<%@ page import="com.liferay.portal.kernel.util.ListUtil" %>
<%@ page import= "com.liferay.portal.kernel.util.PortalUtil" %>
<%@ page import="javax.portlet.PortletURL" %>
<%@ taglib uri="http://liferay.com/tld/asset" prefix="liferay-asset" %>
<%@ taglib uri="http://liferay.com/tld/comment" prefix="liferay-comment" %>
<%@ page import="com.liferay.asset.kernel.AssetRendererFactoryRegistryUtil" %>
<%@ page import="com.liferay.asset.kernel.model.AssetEntry" %>
<%@ page import="com.liferay.asset.kernel.model.AssetRenderer" %>
<%@ page import="com.liferay.asset.kernel.model.AssetRendererFactory" %>
<%@ page import="com.liferay.portal.kernel.util.StringUtil" %>
<%@ page import="com.liferay.portal.kernel.workflow.WorkflowException" %>
<%@ page import="com.liferay.portal.kernel.workflow.WorkflowInstance" %>
<%@ page import="com.liferay.portal.kernel.workflow.WorkflowLog" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>
<%@ taglib uri="http://liferay.com/tld/util" prefix="liferay-util" %>
<%@ page import="com.liferay.portal.workflow.constants.WorkflowWebKeys" %>
<%@ page import="com.liferay.portal.workflow.portlet.tab.WorkflowPortletTab" %>
<%@ page import="com.liferay.taglib.servlet.PipingServletResponse" %>


<liferay-theme:defineObjects />

<portlet:defineObjects />


<%
PortletURL portletURL = renderResponse.createRenderURL();

String currentURL = portletURL.toString();

%>