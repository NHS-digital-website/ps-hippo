<#ftl output_format="HTML">

<#-- @ftlvariable name="section" type="uk.nhs.digital.website.beans.Quote" -->

<#macro quoteSection section>
    <div class="quote-box" aria-label="Quotation">
       <div itemscope itemtype="https://schema.org/Quotation">
         <div class="quote-text" itemprop="text">
          <@hst.html hippohtml=section.quote contentRewriter=gaContentRewriter/>
         </div>
       <div class="quote-box-role">

           <#assign hasPerson = section.person?has_content />
           <#assign hasRole = section.role?has_content />
           <#assign hasOrganisation = section.organisation?has_content />

           <span itemprop="author" itemscope itemtype="https://schema.org/Person">
                <#if hasPerson><span itemprop="name">${section.person}</span><#if hasRole || hasOrganisation>,</#if></#if>
                <#if hasRole><span itemprop="jobtitle">${section.role}</span><#if hasOrganisation>,</#if></#if>
                <#if hasOrganisation>
                    <span itemprop="worksfor" itemscope itemtype="https://schema.org/Organization">
                       <span itemprop="name">${section.organisation}</span>
                   </span>
                </#if>
           </span>
        </div>
      </div>
    </div>
</#macro>
