function [u, v] = LucasKanade(It, It1, rect)

[u, v] = LucasKanadeWithTemplateCorrection(It, It1, rect, [0 0]');

end