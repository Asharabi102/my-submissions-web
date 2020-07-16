package com.rge.forms.workflow.submissions.util;

import java.io.IOException;
import com.liferay.portal.kernel.json.JSONArray;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.util.Validator;
import com.rge.forms.workflow.submissions.dto.WorkflowDTO;

import java.io.PrintWriter;
import java.util.List;

import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;

public class MySubmissionsUtil {
	
	private MySubmissionsUtil() {}
	
	public static void getMySubmissionsData(ResourceRequest resourceRequest, ResourceResponse resourceResponse) throws IOException{
		
		JSONArray jsonArray = JSONFactoryUtil.createJSONArray();
		List<WorkflowDTO> workflowDTOList = (List<WorkflowDTO>) resourceRequest.getAttribute("workflowDTOList");
		
		if(Validator.isNotNull(workflowDTOList) && !workflowDTOList.isEmpty()) {
			for (WorkflowDTO workflowDTO : workflowDTOList) {
				JSONObject jsonObject = JSONFactoryUtil.createJSONObject();
				jsonObject.put("assetTitle", workflowDTO.getAssetTitle());
				jsonObject.put("assetType", workflowDTO.getAssetType());
				jsonObject.put("status", workflowDTO.getStatus());
				jsonObject.put("definition", workflowDTO.getDefinition());
				jsonObject.put("lastActivityDate", workflowDTO.getLastActivityDate());
				jsonObject.put("endDate", workflowDTO.getEndDate());
				jsonArray.put(jsonObject);
			}
		}
		
		writeJSON(resourceResponse, jsonArray.toString());
	}
	
	public static void writeJSON(ResourceResponse resourceResponse, String value) throws IOException {
		
		PrintWriter out = resourceResponse.getWriter();
		out.println(value);
	}

}
