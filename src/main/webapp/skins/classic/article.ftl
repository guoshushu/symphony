<#include "macro-head.ftl">
<#include "macro-pagination-query.ftl">
<!DOCTYPE html>
<html>
    <head>
        <@head title="${article.articleTitle} - ${symphonyLabel}">
        <meta name="keywords" content="${article.articleTags}" />
        <meta name="description" content="${article.articlePreviewContent}"/>
        <#if 1 == article.articleStatus || 1 == article.articleAuthor.userStatus>
        <meta name="robots" content="NOINDEX,NOFOLLOW" />
        </#if>
        </@head>
        <link type="text/css" rel="stylesheet" href="${staticServePath}/js/lib/highlight.js-8.6/styles/github.css">
        <link type="text/css" rel="stylesheet" href="${staticServePath}/css/index${miniPostfix}.css?${staticResourceVersion}" />
        <link type="text/css" rel="stylesheet" href="${staticServePath}/js/lib/editor/codemirror.min.css">
        <link type="text/css" rel="stylesheet" href="${staticServePath}/js/lib/aplayer/APlayer.min.css">
    </head>
    <body>
        <#include "header.ftl">
        <div class="main">
            <div class="wrapper">
                <div class="content">
                    <div class="fn-clear article-action">
                        <span class="fn-right">
                            <#if "" != article.articleToC>
                            <span onclick="Article.toggleToc()" aria-label="${ToCLabel}"
                                  class="fn-pointer tooltipped tooltipped-s"><span class="icon-unordered-list ft-red"></span></span>
                            </#if>
                            <#if isLoggedIn>
                            <span id="thankArticle" aria-label="${thankLabel}" class="fn-pointer tooltipped tooltipped-s" <#if !article.thanked>onclick="Article.thankArticle('${article.oId}', ${article.articleAnonymous})"</#if>><span class="icon-heart<#if article.thanked> ft-red</#if>"></span></span>
                            <span id="voteUp" class="tooltipped tooltipped-s fn-pointer" aria-label="${upLabel} ${article.articleGoodCnt}" onclick="Util.voteUp('${article.oId}', 'article')">
                                <span class="icon-thumbs-up<#if 0==vote> ft-red</#if>"></span></span>
                            <span id="voteDown" class="tooltipped tooltipped-s fn-pointer" aria-label="${downLabel} ${article.articleBadCnt}" onclick="Util.voteDown('${article.oId}', 'article')">
                                <span class="icon-thumbs-down<#if 1==vote> ft-red</#if>"></span></span>
                            <#if isFollowing>
                            <span class="tooltipped tooltipped-s fn-pointer" aria-label="${uncollectLabel} ${article.articleCollectCnt}" onclick="Util.unfollow(this, '${article.oId}', 'article', ${article.articleCollectCnt})"><span class="icon-star ft-red"></span></span>
                            <#else>
                            <span class="tooltipped tooltipped-s fn-pointer" aria-label="${collectLabel} ${article.articleCollectCnt}" onclick="Util.follow(this, '${article.oId}', 'article', ${article.articleCollectCnt})"><span class="icon-star"></span></span>
                            </#if>
                            <span onclick="Article.revision('${article.oId}')" aria-label="${historyLabel}"
                                  class="fn-pointer tooltipped tooltipped-s"><span class="icon-refresh"></span></span>
                            </#if>
                            <#if article.isMyArticle && 3 != article.articleType>
                            <a href="/update?id=${article.oId}" aria-label="${editLabel}" class="tooltipped tooltipped-s"><span class="icon-edit"></span></a>
                            </#if>
                            <#if article.isMyArticle>
                            <a class="tooltipped tooltipped-s" aria-label="${stickLabel}" 
                               href="javascript:Article.stick('${article.oId}')"><span class="icon-chevron-up"></span></a>
                            </#if>
                            <#if isAdminLoggedIn>
                            <a class="tooltipped tooltipped-s" href="/admin/article/${article.oId}" aria-label="${adminLabel}"><span class="icon-setting"></span></a>
                            </#if>
                        </span>
                    </div>

                    <h2 class="article-title">
                        <#if 1 == article.articleType>
                        <span class="icon-locked" title="${discussionLabel}"></span>
                        <#elseif 2 == article.articleType>
                        <span class="icon-feed" title="${cityBroadcastLabel}"></span>
                        <#elseif 3 == article.articleType>
                        <span class="icon-video" title="${thoughtLabel}"></span>
                        </#if>
                        <a href="${article.articlePermalink}" rel="bookmark">
                            ${article.articleTitleEmoj}
                        </a>
                    </h2> 
                    <div class="article-info fn-flex">
                        <#if article.articleAnonymous == 0>
                        <a rel="author" href="/member/${article.articleAuthorName}"
                            title="${article.articleAuthorName}"></a></#if><div class="avatar" style="background-image:url('${article.articleAuthorThumbnailURL}-64.jpg?${article.articleAuthor.userUpdateTime?c}')"></div><#if article.articleAnonymous == 0></a></#if>
                        <div class="fn-flex-1">
                            <#if article.articleAnonymous == 0>
                            <a rel="author" href="/member/${article.articleAuthorName}" class="ft-black"
                               title="${article.articleAuthorName}"></#if><strong>${article.articleAuthorName}</strong><#if article.articleAnonymous == 0></a></#if>
                            <span class="ft-gray">
                                <#if article.clientArticlePermalink?? && 0 < article.clientArticlePermalink?length>
                                • <a href="${article.clientArticlePermalink}" target="_blank" rel="nofollow"><span class="ft-green">${sourceLabel}</span></a>
                                </#if>
                                •
                                ${article.timeAgo}   
                                •
                                ${viewLabel}
                                <#if article.articleViewCount < 1000>
                                ${article.articleViewCount}
                                <#else>
                                ${article.articleViewCntDisplayFormat}
                                </#if>
                                •
                            </span>
                            <a title="${cmtLabel}" rel="nofollow" class="ft-gray" href="#comments">
                                ${cmtLabel} ${article.articleCommentCount}
                            </a> 
                            <br/>
                            <#list article.articleTags?split(",") as articleTag>
                            <a rel="tag" class="tag" href="/tag/${articleTag?url('UTF-8')}">
                                ${articleTag}
                            </a>&nbsp;
                            </#list>
                            <#if 0 == article.articleAuthor.userUAStatus>
                            <span id="articltVia" class="ft-fade" data-ua="${article.articleUA}"></span>
                            </#if>
                        </div>
                    </div>

                    <#if 3 != article.articleType>
                    <div class="content-reset article-content">${article.articleContent}</div>
                    <#else>
                    <div id="thoughtProgress"><span class="bar"></span><span class="icon-video"></span><div data-text="" class="content-reset" id="thoughtProgressPreview"></div></div>
                    <div class="content-reset article-content"></div>
                    </#if>

                    <div class="fn-clear">
                        <div class="share fn-right">
                            <div id="qrCode" class="fn-none"></div>
                            <span class="tooltipped tooltipped-s" aria-label="share to wechat" data-type="wechat"><span class="icon-wechat"></span></span>
                            <span class="tooltipped tooltipped-s" aria-label="share to weibo" data-type="weibo"><span class="icon-weibo"></span></span>
                            <span class="tooltipped tooltipped-s" aria-label="share to twitter" data-type="twitter"><span class="icon-twitter"></span></span>
                            <span class="tooltipped tooltipped-s" aria-label="share to google" data-type="google"><span class="icon-google"></span></span>
                            <span class="tooltipped tooltipped-sw ft-red" data-type="copy"
                                  aria-label="${copyLabel}"
                                  id="shareClipboard"
                                  data-clipboard-text="${servePath}${article.articlePermalink}<#if isLoggedIn>?r=${currentUser.userName}</#if>"><span 
                                    class="icon-copy"></span></span>
                        </div>
                    </div>
                    <#if 0 < article.articleRewardPoint>
                    <div class="content-reset" id="articleRewardContent"<#if !article.rewarded> class="reward"</#if>>
                         <#if !article.rewarded>
                         <span>
                            ${rewardTipLabel?replace("{articleId}", article.oId)?replace("{point}", article.articleRewardPoint)}
                        </span>
                        <#else>
                        ${article.articleRewardContent}
                        </#if>
                    </div>
                    </#if>
                    <#if 1 == userCommentViewMode>
                    <#if isLoggedIn>
                    <#if discussionViewable && article.articleCommentable>
                    <div class="form fn-clear comment-wrap">
                        <br/>
                        <textarea id="commentContent" placeholder="${commentEditorPlaceholderLabel}"></textarea>
                        <div class="tip" id="addCommentTip"></div>

                        <div class="fn-clear comment-submit">
                            <span class="responsive-hide">    
                                Markdown
                                <a href="javascript:void(0)" onclick="$('.grammar').slideToggle()">${baseGrammarLabel}</a>
                                <a target="_blank" href="http://daringfireball.net/projects/markdown/syntax">${allGrammarLabel}</a>
                                |
                                <a target="_blank" href="${servePath}/emoji/index.html">Emoji</a>
                            </span>
                            <div class="fn-right">
                                <label class="cmt-anonymous">${anonymousLabel}<input type="checkbox" id="commentAnonymous"></label>
                                <button class="red" onclick="Comment.add('${article.oId}', '${csrfToken}')">${replayLabel}</button>
                            </div>
                        </div>

                    </div>
                    <div class="grammar fn-none fn-clear">
                        ${markdwonGrammarLabel}
                    </div>
                    </#if>
                    <#else>
                    <div class="comment-login">
                        <a rel="nofollow" href="javascript:window.scrollTo(0,0);Util.showLogin();">${loginDiscussLabel}</a>
                    </div>
                    </#if>
                    </#if>
                    <div class="fn-clear">
                        <div class="list" id="comments">
                            <div class="fn-clear comment-header">
                                <h2 class="fn-left">${article.articleCommentCount} ${cmtLabel}</h2>
                                <span<#if article.articleComments?size == 0> class="fn-none"</#if>>
                                    <a class="tooltipped tooltipped-sw fn-right" href="#bottomComment" aria-label="${jumpToBottomCommentLabel}"><span class="icon-chevron-down"></span></a>
                                    <a class="tooltipped tooltipped-sw fn-right" href="javascript:Comment.exchangeCmtSort(${userCommentViewMode})"
                                       aria-label="<#if 0 == userCommentViewMode>${changeToLabel}${realTimeLabel}${cmtViewModeLabel}<#else>${changeToLabel}${traditionLabel}${cmtViewModeLabel}</#if>"><span class="icon-<#if 0 == userCommentViewMode>sortasc<#else>time</#if>"></span></a>
                                </span>
                            </div>
                            <ul>
                                <#assign notificationCmtIds = "">
                                <#list article.articleComments as comment>
                                <#assign notificationCmtIds = notificationCmtIds + comment.oId>
                                <#if comment_has_next><#assign notificationCmtIds = notificationCmtIds + ","></#if>
                                <li id="${comment.oId}"<#if comment.commentStatus == 1>class="shield"</#if>>
                                    <#if !comment?has_next><div id="bottomComment"></div></#if>
                                    <div class="fn-flex">
                                        <#if !comment.fromClient>
                                        <#if comment.commentAnonymous == 0>
                                        <a rel="nofollow" href="/member/${comment.commentAuthorName}"></#if>
                                            <div class="avatar" 
                                                 title="${comment.commentAuthorName}" style="background-image:url('${comment.commentAuthorThumbnailURL}-64.jpg?${comment.commenter.userUpdateTime?c}')"></div>
                                        <#if comment.commentAnonymous == 0></a></#if>
                                        <#else>
                                        <div class="avatar" 
                                             title="${comment.commentAuthorName}" style="background-image:url('${comment.commentAuthorThumbnailURL}-64.jpg?${comment.commenter.userUpdateTime?c}')"></div>
                                        </#if>
                                        <div class="fn-flex-1 comment-content">
                                            <div class="fn-clear comment-info">
                                                <span class="fn-left">
                                                    <#if !comment.fromClient>
                                                    <#if comment.commentAnonymous == 0>
                                                    <a rel="nofollow" href="/member/${comment.commentAuthorName}"
                                                       title="${comment.commentAuthorName}"></#if>${comment.commentAuthorName}<#if comment.commentAnonymous == 0></a></#if><#else>${comment.commentAuthorName} 
                                                       via <a rel="nofollow" href="https://hacpai.com/article/1457158841475">API</a></#if><span class="ft-fade ft-smaller">&nbsp;•&nbsp;${comment.timeAgo} 
                                                        <#if 0 == comment.commenter.userUAStatus><span class="cmt-via" data-ua="${comment.commentUA}"></span></#if>
                                                    </span>
                                                    <#if comment.rewardedCnt gt 0>
                                                    <#assign hasRewarded = isLoggedIn && comment.commentAuthorId != currentUser.oId && comment.rewarded>
                                                    <#if hasRewarded>
                                                    <span title="${thankedLabel}">
                                                    </#if>   
                                                        <span class="icon-heart ft-smaller <#if hasRewarded>ft-red<#else>ft-fade</#if>"></span><span
                                                            class="ft-smaller <#if hasRewarded>ft-red<#else>ft-fade</#if>" 
                                                            id='${comment.oId}RewardedCnt'> ${comment.rewardedCnt}</span> 
                                                    <#if hasRewarded>
                                                    </span>
                                                    </#if>
                                                    </#if>
                                                </span>
                                                <span class="fn-right">
                                                    <#if isLoggedIn>
                                                    <#if comment.commentAuthorId != currentUser.oId>
                                                    <#if !comment.rewarded>
                                                    <span class='fn-none thx fn-pointer ft-smaller ft-fade' id='${comment.oId}Thx'
                                                          onclick="Comment.thank('${comment.oId}', '${csrfToken}', '${comment.commentThankLabel}', '${thankedLabel}', ${comment.commentAnonymous})">${thankLabel}</span>
                                                    </#if>
                                                    </#if>
                                                    <#if comment.commentAuthorName != currentUser.userName && comment.commentAnonymous == 0>
                                                    <span aria-label="@${comment.commentAuthorName}" class="fn-pointer tooltipped tooltipped-s" onclick="Comment.replay('@${comment.commentAuthorName} ')"><span class="icon-reply"></span></span>
                                                    </#if>
                                                    </#if>
                                                    <#if isAdminLoggedIn>
                                                    <a class="tooltipped tooltipped-s a-icon" href="/admin/comment/${comment.oId}" aria-label="${adminLabel}"><span class="icon-setting"></span></a>
                                                    </#if>
                                                    #<i><#if 0 == userCommentViewMode>${(paginationCurrentPageNum - 1) * articleCommentsPageSize + comment_index + 1}<#else>${article.articleCommentCount - ((paginationCurrentPageNum - 1) * articleCommentsPageSize + comment_index)}</#if></i>
                                                </span>    
                                            </div>
                                            <div class="content-reset comment">
                                                ${comment.commentContent}
                                            </div>
                                        </div>
                                    </div>
                                </li>
                                </#list>  
                            </ul>
                        </div>
                        <@pagination url=article.articlePermalink query="m=${userCommentViewMode}" />
                    </div>
                    <#if 0 == userCommentViewMode>
                    <#if isLoggedIn>
                    <#if discussionViewable && article.articleCommentable>
                    <div class="form fn-clear comment-wrap">
                        <br/>
                        <textarea id="commentContent" placeholder="${commentEditorPlaceholderLabel}"></textarea>
                        <div class="tip" id="addCommentTip"></div>

                        <div class="fn-clear comment-submit">
                            <span class="responsive-hide">    
                                Markdown
                                <a href="javascript:void(0)" onclick="$('.grammar').slideToggle()">${baseGrammarLabel}</a>
                                <a target="_blank" href="http://daringfireball.net/projects/markdown/syntax">${allGrammarLabel}</a>
                                |
                                <a target="_blank" href="${servePath}/emoji/index.html">Emoji</a>
                            </span>
                            <div class="fn-right">
                                <label class="cmt-anonymous">${anonymousLabel}<input type="checkbox" id="commentAnonymous"></label>
                                <button class="red" onclick="Comment.add('${article.oId}', '${csrfToken}')">${replayLabel}</button>
                            </div>
                        </div>

                    </div>
                    <div class="grammar fn-none fn-clear">
                        ${markdwonGrammarLabel}
                    </div>
                    </#if>
                    <#else>
                    <div class="comment-login">
                        <a rel="nofollow" href="javascript:window.scrollTo(0,0);Util.showLogin();">${loginDiscussLabel}</a>
                    </div>
                    </#if>
                    </#if>
                </div>
                <div class="side">
                    <#include 'common/person-info.ftl'/>
                    
                    <#if ADLabel!="">
                    ${ADLabel}
                    </#if>
                    <#if "" != article.articleToC && 3 != article.articleType>
                    <div class="module" id="articleToC">
                        <div class="module-header">
                            <h2>
                                ${ToCLabel}
                                <a href="javascript:Article.toggleToc()" class="fn-right ft-13 ft-fade">X</a>
                            </h2>
                        </div>
                        <div class="module-panel">
                             ${article.articleToC}
                        </div>
                    </div>
                    </#if>
                    
                    <#if sideRelevantArticles?size != 0>
                    <div class="module">
                        <div class="module-header">
                            <h2>
                                ${relativeArticleLabel}
                            </h2>
                        </div>
                        <div class="module-panel">
                            <ul class="module-list">
                                <#list sideRelevantArticles as relevantArticle>
                                <li<#if !relevantArticle_has_next> class="last"</#if>>
                                    <#if "someone" != relevantArticle.articleAuthorName>
                                    <a rel="nofollow" 
                                   href="/member/${relevantArticle.articleAuthorName}"></#if>
                                        <span class="avatar-small slogan tooltipped tooltipped-se" aria-label="${relevantArticle.articleAuthorName}"
                                   style="background-image:url('${relevantArticle.articleAuthorThumbnailURL}-64.jpg?${relevantArticle.articleAuthor.userUpdateTime?c}')"
                                   ></span>
                                    <#if "someone" != relevantArticle.articleAuthorName></a></#if>
                                    <a rel="nofollow" class="title" href="${relevantArticle.articlePermalink}">${relevantArticle.articleTitleEmoj}</a>
                                </li>
                                </#list>
                            </ul>
                        </div>
                    </div>
                    </#if>
                    
                    <#if sideRandomArticles?size != 0>
                    <div class="module">
                        <div class="module-header">
                            <h2>
                                ${randomArticleLabel}
                            </h2>
                        </div>
                        <div class="module-panel">
                            <ul class="module-list">
                                <#list sideRandomArticles as randomArticle>
                                <li<#if !randomArticle_has_next> class="last"</#if>>
                                    <#if "someone" != randomArticle.articleAuthorName>
                                    <a  rel="nofollow"
                                   href="/member/${randomArticle.articleAuthorName}"></#if>
                                        <span class="avatar-small slogan tooltipped tooltipped-se"
                                   aria-label="${randomArticle.articleAuthorName}"
                                   style="background-image:url('${randomArticle.articleAuthorThumbnailURL}-64.jpg?${randomArticle.articleAuthor.userUpdateTime?c}')"></span>
                                    <#if "someone" != randomArticle.articleAuthorName></a></#if>
                                    <a class="title" rel="nofollow" href="${randomArticle.articlePermalink}">${randomArticle.articleTitleEmoj}</a>
                                </li>
                                </#list>
                            </ul>
                        </div>
                    </div>
                    </#if>
                </div>
            </div>
        </div>
        <div id="heatBar">
            <i class="heat" style="width:${article.articleHeat*3}px"></i>
        </div>
        <div id="revision"><div id="revisions"></div></div>
        <#include "footer.ftl">
        <script src="${staticServePath}/js/lib/compress/article-libs.min.js"></script>
        <script type="text/javascript" src="${staticServePath}/js/article${miniPostfix}.js?${staticResourceVersion}"></script>
        <script type="text/javascript" src="${staticServePath}/js/channel${miniPostfix}.js?${staticResourceVersion}"></script>
        <script>
            Label.commentErrorLabel = "${commentErrorLabel}";
            Label.symphonyLabel = "${symphonyLabel}";
            Label.rewardConfirmLabel = "${rewardConfirmLabel?replace('{point}', article.articleRewardPoint)}";
            Label.thankArticleConfirmLabel = "${thankArticleConfirmLabel?replace('{point}', pointThankArticle)}";
            Label.thankSentLabel = "${thankSentLabel}";
            Label.articleOId = "${article.oId}";
            Label.articleTitle = "${article.articleTitle}";
            Label.articlePermalink = "${article.articlePermalink}";
            Label.recordDeniedLabel = "${recordDeniedLabel}";
            Label.recordDeviceNotFoundLabel = "${recordDeviceNotFoundLabel}";
            Label.csrfToken = "${csrfToken}";
            Label.upLabel = "${upLabel}";
            Label.downLabel = "${downLabel}";
            Label.uploadLabel = "${uploadLabel}";
            Label.userCommentViewMode = ${userCommentViewMode};
            Label.stickConfirmLabel = "${stickConfirmLabel}";
            Label.audioRecordingLabel = '${audioRecordingLabel}';
            Label.uploadingLabel = '${uploadingLabel}';
            Label.copiedLabel = '${copiedLabel}';
            Label.copyLabel = '${copyLabel}';
            Label.noRevisionLabel = "${noRevisionLabel}";
            qiniuToken = "${qiniuUploadToken}";
            qiniuDomain = "${qiniuDomain}";
            <#if isLoggedIn>
                    Label.currentUserName = '${currentUser.userName}';
            </#if>
            // Init [Article] channel
            ArticleChannel.init("${wsScheme}://${serverHost}:${serverPort}/article-channel?articleId=${article.oId}&articleType=${article.articleType}");
            $(document).ready(function () {
                 // jQuery File Upload
                Util.uploadFile({
                "type": "img",
                        "id": "fileUpload",
                        "pasteZone": $(".CodeMirror"),
                        "qiniuUploadToken": "${qiniuUploadToken}",
                        "editor": Comment.editor,
                        "uploadingLabel": "${uploadingLabel}",
                        "qiniuDomain": "${qiniuDomain}",
                        "imgMaxSize": ${imgMaxSize?c},
                        "fileMaxSize": ${fileMaxSize?c}
                });
            });
           
            <#if 3 == article.articleType>
                    Article.playThought('${article.articleContent}');
            </#if>
            Comment.init(${isLoggedIn?c});
            <#if isLoggedIn>
            Article.makeNotificationRead('${article.oId}', '${notificationCmtIds}');
            
            setTimeout(function() {
                Util.setUnreadNotificationCount();
            }, 1000);
            </#if>
        </script>
        <script type="text/javascript" src="//cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>
        <script type="text/x-mathjax-config">
            MathJax.Hub.Config({
                tex2jax: {
                    inlineMath: [['$','$'], ["\\(","\\)"] ],
                    displayMath: [['$$','$$']],
                    processEscapes: true,
                    processEnvironments: true,
                    skipTags: ['pre','code'],
                }
            });
        </script>
        <script type="text/x-mathjax-config">
            MathJax.Hub.Queue(function() {
                var all = MathJax.Hub.getAllJax(), i;
                for(i = 0; i < all.length; i += 1) {
                    all[i].SourceElement().parentNode.className += 'has-jax';
                }
            });
        </script>
    </body>
</html>
