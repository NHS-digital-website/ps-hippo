import './utils/public-path';

/**
 * Scripts to load just before `</body>`
 */
import {initCookieConsent} from "./relevance/relevance-cookie";
import "./intranet/intranet";

initCookieConsent();
